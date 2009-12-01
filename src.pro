TEMPLATE = subdirs

INSTALLS += apache scripts web

apache.path = $$(DESTDIR)/etc/apache2/sites-available
apache.files += 099-githaven

scripts.path = $$(DESTDIR)/usr/bin
scripts.files += bin/*

web.path = $$(DESTDIR)/usr/share/githaven
web.files = web/

