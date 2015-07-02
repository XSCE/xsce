# XSCE Home Page and Web Portal Multilingual Support

# XS public web pages - must be publically accessible

<Directory /var/www/html/xs-portal>
# Enable Multiviews option for multiple language support
Options +MultiViews

# DirectoryIndex: MultiViews also looks for .png and .gif, this enables
# a language dependent display of images. E.g. flag => flag.lb.png
DirectoryIndex index index.php index.html index.htm index.png index.gif

# languages are in 010-xsce.con

# Add rewrites for language menu

RewriteEngine On
RewriteBase /xs-portal/
RewriteCond %{QUERY_STRING} ^(en|es|fr|ht|hi)$
RewriteRule ^((en|es|fr|ht|hi)/)?(.*?)(\.(html?|php|en|es|fr|ht|hi))*$ \
        /xs-portal/%1/$3? [E=LANG:%1,R=302,L]

RewriteRule ^(en|es|fr|ht|hi)/(.*) $2 [E=LANG:$1]

# mod_rewrite prepends REDIRECT_ to each set Env Var

SetEnvIf REDIRECT_LANG en prefer-language=en Header append Vary cookie
SetEnvIf REDIRECT_LANG es prefer-language=es Header append Vary cookie
SetEnvIf REDIRECT_LANG fr prefer-language=fr Header append Vary cookie
SetEnvIf REDIRECT_LANG ht prefer-language=ht Header append Vary cookie
SetEnvIf REDIRECT_LANG hi prefer-language=hi Header append Vary cookie
Require all granted
</Directory>
