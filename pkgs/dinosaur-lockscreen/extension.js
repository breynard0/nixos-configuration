import Clutter from 'gi://Clutter';
import Cogl from 'gi://Cogl';
import Gio from 'gi://Gio';
import GLib from 'gi://GLib';
import St from 'gi://St';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const FFMPEG = '@ffmpeg@';
const MUSIC_MS = Number('@musicSeconds@') * 1000;
// Roughly how long the player takes from being spawned to making sound.
const PLAYER_START_MS = 50;

const DANCE_FRAMES = 16;
const DANCE_FRAME_MS = 60;
const DANCE_SIZE = [800, 800];
const STATIC_FRAMES = 13;
const STATIC_FRAME_MS = 40;
const STATIC_SIZE = [500, 400];
const STATIC_OPACITY = 51;

const COLORS = [
    [139, 28, 134],
    [29, 28, 121],
    [48, 153, 44],
    [170, 148, 51],
    [168, 44, 39],
];
const COLOR_CYCLE_MS = 12000;

const PHRASES = [
    'No one is around to help',
    'Life is hard, life is stressful',
    'I need peace and tranquility',
    "I don't have to prove myself to anyone",
];
const PHRASE_DELAY_MS = 2000;
const PHRASE_MS = 6000;

// [colour, [x, y] offsets for the two flicker states]
const TEXT_LAYERS = [
    ['#ea36af', [[1, 0], [2, 0.5]]],
    ['#75fa69', [[-2, 0], [-1, -0.5]]],
    ['#ffffff', [[0, 0], [0, 0]]],
];

const INHIBIT_SUSPEND_AND_IDLE = 12;
const UI_FADE_MS = 300;

class MonitorView {
    constructor(monitor, assetDir, scaleFactor) {
        const {x, y, width, height} = monitor;
        this._scaleFactor = scaleFactor;

        this.actor = new Clutter.Actor({x, y, width, height, clip_to_allocation: true});

        const size = Math.round(Math.min(height * 0.5, width * 0.6));
        this._dancer = new Clutter.Actor({
            x: Math.round((width - size) / 2),
            y: Math.round(height * 0.46),
            width: size,
            height: size,
            scale_x: 0.3,
            scale_y: 0.3,
            opacity: 0,
        });
        this._dancer.set_pivot_point(0.5, 0.5);
        this._danceFrames = this._loadFrames(this._dancer, assetDir, 'dance', DANCE_FRAMES, DANCE_SIZE, size / DANCE_SIZE[0]);
        this.actor.add_child(this._dancer);

        const fontSize = Math.round(height * 0.044 / scaleFactor);
        this._labels = TEXT_LAYERS.map(([color]) => {
            const label = new St.Label({
                x: 0,
                y: Math.round(height * 0.912),
                width,
                text: ' ',
                style: `font-family: VT323, monospace; font-weight: bold; font-size: ${fontSize}px; text-align: center; color: ${color};`,
            });
            this.actor.add_child(label);
            return label;
        });

        const cover = Math.max(width / STATIC_SIZE[0], height / STATIC_SIZE[1]);
        const staticWidth = Math.ceil(STATIC_SIZE[0] * cover);
        const staticHeight = Math.ceil(STATIC_SIZE[1] * cover);
        this._static = new Clutter.Actor({
            x: Math.round((width - staticWidth) / 2),
            y: Math.round((height - staticHeight) / 2),
            width: staticWidth,
            height: staticHeight,
            opacity: STATIC_OPACITY,
        });
        this._staticFrames = this._loadFrames(this._static, assetDir, 'static', STATIC_FRAMES, STATIC_SIZE, cover);
        this.actor.add_child(this._static);

        this._dancer.ease({
            scale_x: 1,
            scale_y: 1,
            opacity: 178,
            duration: 3000,
            mode: Clutter.AnimationMode.EASE_IN_OUT_QUAD,
            onComplete: () => (this._dancer.opacity = 255),
        });
    }

    // The texture cache sizes each actor to its image once loaded, so the
    // frames are scaled as a group instead of resized one by one.
    _loadFrames(parent, assetDir, name, count, [width, height], scale) {
        const holder = new Clutter.Actor({width, height, scale_x: scale, scale_y: scale});
        parent.add_child(holder);

        const cache = St.TextureCache.get_default();
        const frames = [];
        for (let i = 0; i < count; i++) {
            const file = assetDir.get_child(`${name}-${String(i).padStart(2, '0')}.png`);
            const frame = cache.load_file_async(file, -1, -1, 1, 1);
            frame.set_content_scaling_filters(Clutter.ScalingFilter.TRILINEAR, Clutter.ScalingFilter.LINEAR);
            frame.visible = i === 0;
            holder.add_child(frame);
            frames.push(frame);
        }
        return frames;
    }

    update(elapsed, tick) {
        const dance = Math.floor(elapsed / DANCE_FRAME_MS) % DANCE_FRAMES;
        this._danceFrames.forEach((frame, i) => (frame.visible = i === dance));

        const noise = Math.floor(elapsed / STATIC_FRAME_MS) % STATIC_FRAMES;
        this._staticFrames.forEach((frame, i) => (frame.visible = i === noise));

        const segment = COLOR_CYCLE_MS / COLORS.length;
        const position = (elapsed % COLOR_CYCLE_MS) / segment;
        const from = COLORS[Math.floor(position) % COLORS.length];
        const to = COLORS[(Math.floor(position) + 1) % COLORS.length];
        const mix = position - Math.floor(position);
        const channel = i => Math.round(from[i] + (to[i] - from[i]) * mix);
        this.actor.background_color = new Cogl.Color({
            red: channel(0),
            green: channel(1),
            blue: channel(2),
            alpha: 255,
        });

        const text = elapsed < PHRASE_DELAY_MS
            ? ' '
            : PHRASES[Math.floor((elapsed - PHRASE_DELAY_MS) / PHRASE_MS) % PHRASES.length];
        this._labels.forEach((label, i) => {
            if (label.text !== text)
                label.text = text;
            const [dx, dy] = TEXT_LAYERS[i][1][tick % 2];
            label.set_translation(dx * this._scaleFactor, dy * this._scaleFactor, 0);
        });
    }
}

export default class DinosaurLockscreen extends Extension {
    enable() {
        this._muted = true;
        this._uiHidden = false;
        this._wantInhibit = false;

        this._group = Main.screenShield._lockDialogGroup;
        this._group.connectObject('child-added', (_group, child) => this._attach(child), this);

        this._monitorManager = global.backend.get_monitor_manager();
        this._screenOn = true;
        this._monitorManager.connectObject('power-save-mode-changed', () => this._readPowerSave(), this);
        this._readPowerSave();

        Main.layoutManager.connectObject('monitors-changed', () => {
            const dialog = this._dialog;
            if (dialog) {
                this._detach();
                this._attach(dialog);
            }
        }, this);

        this._attach(Main.screenShield._dialog);
    }

    disable() {
        this._detach();
        this._group.disconnectObject(this);
        this._monitorManager.disconnectObject(this);
        Main.layoutManager.disconnectObject(this);
        this._group = null;
        this._monitorManager = null;
    }

    _attach(dialog) {
        if (!dialog?._backgroundGroup || !dialog._stack || dialog === this._dialog)
            return;
        this._detach();

        this._dialog = dialog;
        this._mainBox = dialog._stack.get_parent();
        dialog.connectObject(
            'destroy', () => this._detach(),
            'captured-event', (_actor, event) => this._onCapturedEvent(event),
            this);

        const {scaleFactor} = St.ThemeContext.get_for_stage(global.stage);
        const assetDir = this.dir.get_child('assets');

        this._layer = new Clutter.Actor();
        dialog.insert_child_above(this._layer, dialog._backgroundGroup);
        this._views = Main.layoutManager.monitors.map(monitor => {
            const view = new MonitorView(monitor, assetDir, scaleFactor);
            this._layer.add_child(view.actor);
            return view;
        });

        this._musicButton = this._addButton('audio-volume-muted-symbolic', 'Toggle music');
        this._hideButton = this._addButton('view-conceal-symbolic', 'Hide clock and login');
        const primary = Main.layoutManager.primaryMonitor;
        const [, , buttonWidth, buttonHeight] = this._musicButton.get_preferred_size();
        const buttonY = primary.y + primary.height - buttonHeight * 2;
        this._musicButton.set_position(primary.x + buttonWidth, buttonY);
        this._hideButton.set_position(primary.x + buttonWidth * 2.5, buttonY);

        this._startTime = GLib.get_monotonic_time();
        this._tick = 0;
        this._syncPower();
    }

    _detach() {
        if (!this._dialog)
            return;

        this._stopTimer();
        this._setMuted(true);
        this._setUiHidden(false, false);

        this._dialog.disconnectObject(this);
        this._layer.destroy();
        this._musicButton.destroy();
        this._hideButton.destroy();
        this._dialog = null;
        this._mainBox = null;
        this._layer = null;
        this._views = null;
        this._musicButton = null;
        this._hideButton = null;
    }

    _addButton(iconName, accessibleName) {
        const button = new St.Button({
            style_class: 'login-dialog-button switch-user-button',
            icon_name: iconName,
            accessible_name: accessibleName,
            reactive: true,
        });
        this._dialog.add_child(button);
        return button;
    }

    // The signal only carries the reason for the change, not the new mode.
    _readPowerSave() {
        this._dbusCall('org.gnome.Mutter.DisplayConfig', '/org/gnome/Mutter/DisplayConfig',
            'org.freedesktop.DBus.Properties', 'Get',
            new GLib.Variant('(ss)', ['org.gnome.Mutter.DisplayConfig', 'PowerSaveMode']),
            reply => {
                if (!this._monitorManager)
                    return;
                this._screenOn = (reply?.deepUnpack()[0].deepUnpack() ?? 0) <= 0;
                this._syncPower();
            });
    }

    _syncPower() {
        if (!this._dialog)
            return;

        if (this._screenOn) {
            this._startTimer();
        } else {
            this._stopTimer();
            this._setMuted(true);
        }
    }

    _startTimer() {
        if (this._timerId)
            return;
        this._update();
        this._timerId = GLib.timeout_add(GLib.PRIORITY_DEFAULT, DANCE_FRAME_MS, () => {
            this._update();
            return GLib.SOURCE_CONTINUE;
        });
    }

    _stopTimer() {
        if (this._timerId)
            GLib.source_remove(this._timerId);
        this._timerId = 0;
    }

    _update() {
        const elapsed = (GLib.get_monotonic_time() - this._startTime) / 1000;
        this._tick++;
        for (const view of this._views)
            view.update(elapsed, this._tick);
    }

    _setMuted(muted) {
        this._muted = muted;
        if (this._musicButton)
            this._musicButton.icon_name = muted ? 'audio-volume-muted-symbolic' : 'audio-volume-high-symbolic';

        if (muted) {
            const player = this._player;
            this._player = null;
            player?.force_exit();
        } else if (!this._player) {
            this._play();
        }
    }

    // The track is started at the point it would have reached had it been
    // playing since the animation began, so the two stay in step however
    // often the music is toggled.
    _play() {
        const elapsed = (GLib.get_monotonic_time() - this._startTime) / 1000;
        const offset = ((elapsed + PLAYER_START_MS) % MUSIC_MS) / 1000;
        let player;
        try {
            player = Gio.Subprocess.new(
                [
                    FFMPEG, '-nostdin', '-v', 'error',
                    '-stream_loop', '-1', '-ss', offset.toFixed(3),
                    '-i', this.dir.get_child('assets').get_child('music.ogg').get_path(),
                    '-f', 'pulse', 'Dinosaur Lock Screen',
                ],
                Gio.SubprocessFlags.STDOUT_SILENCE | Gio.SubprocessFlags.STDERR_SILENCE);
        } catch (e) {
            console.error(e);
            this._setMuted(true);
            return;
        }
        this._player = player;
        player.wait_async(null, () => {
            if (this._player !== player)
                return;
            this._player = null;
            this._setMuted(true);
        });
    }

    _setUiHidden(hidden, animate = true) {
        if (this._uiHidden === hidden)
            return;
        this._uiHidden = hidden;

        if (hidden)
            this._dialog._showClock();

        this._hideButton.icon_name = hidden ? 'view-reveal-symbolic' : 'view-conceal-symbolic';
        this._mainBox.remove_all_transitions();
        this._mainBox.ease({
            opacity: hidden ? 0 : 255,
            duration: animate ? UI_FADE_MS : 0,
            mode: Clutter.AnimationMode.EASE_OUT_QUAD,
        });

        this._setInhibited(hidden);
    }

    // The dialog's own click and swipe gestures claim every press before a
    // button inside it can, so presses are handled here on the way down.
    _onCapturedEvent(event) {
        const type = event.type();

        if (type === Clutter.EventType.KEY_PRESS) {
            this._setUiHidden(false);
            return Clutter.EVENT_PROPAGATE;
        }

        if (type !== Clutter.EventType.BUTTON_PRESS && type !== Clutter.EventType.TOUCH_BEGIN)
            return Clutter.EVENT_PROPAGATE;

        const target = global.stage.get_event_actor(event);
        if (target && this._musicButton.contains(target))
            this._setMuted(!this._muted);
        else if (target && this._hideButton.contains(target))
            this._setUiHidden(!this._uiHidden);
        else if (this._uiHidden)
            this._setUiHidden(false);
        else
            return Clutter.EVENT_PROPAGATE;

        return Clutter.EVENT_STOP;
    }

    _setInhibited(inhibited) {
        this._wantInhibit = inhibited;

        if (inhibited && !this._inhibitCookie && !this._inhibitPending) {
            this._inhibitPending = true;
            this._callSessionManager('Inhibit',
                new GLib.Variant('(susu)', [this.uuid, 0, 'Lock screen animation is showing', INHIBIT_SUSPEND_AND_IDLE]),
                reply => {
                    this._inhibitPending = false;
                    this._inhibitCookie = reply?.deepUnpack()[0] ?? 0;
                    if (!this._wantInhibit)
                        this._setInhibited(false);
                });
        } else if (!inhibited && this._inhibitCookie) {
            this._callSessionManager('Uninhibit', new GLib.Variant('(u)', [this._inhibitCookie]));
            this._inhibitCookie = 0;
        }
    }

    _callSessionManager(method, parameters, onReply = null) {
        this._dbusCall('org.gnome.SessionManager', '/org/gnome/SessionManager',
            'org.gnome.SessionManager', method, parameters, onReply);
    }

    _dbusCall(name, path, iface, method, parameters, onReply = null) {
        Gio.DBus.session.call(
            name, path, iface, method, parameters, null, Gio.DBusCallFlags.NONE, -1, null,
            (connection, result) => {
                let reply = null;
                try {
                    reply = connection.call_finish(result);
                } catch (e) {
                    console.error(e);
                }
                onReply?.(reply);
            });
    }
}
