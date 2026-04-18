{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/*" = "org.lite_xl.lite_xl.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "application/pdf" = "okularApplication_pdf.desktop";
      "image/*" = "qimgv.desktop";
    };
  };
}