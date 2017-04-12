appledoc \
--project-name YouboraLib \
--project-company "Nice People At Work" \
--company-id com.nice \
--output ./doc-private \
--docset-feed-url "http://www.npaw.com/npaw/%DOCSETATOMFILENAME" \
--docset-package-url "http://www.npaw.com/npaw/%DOCSETPACKAGEFILENAME" \
--publish-docset \
--no-create-docset \
--explicit-crossref \
./YouboraLib/

#open ./doc-private/html
