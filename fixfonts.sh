cd /root/luckmall/theme/vinexus

# 1) functions.php：把被墙的 Google 字体换成本地 fonts.css
sed -i "s#https://fonts.googleapis.com/css2[^']*#/wp-content/themes/vinexus/assets/css/fonts.css#g" functions.php

# 2) 生成本地字体 CSS
mkdir -p assets/css assets/fonts
cat > assets/css/fonts.css <<'CSS'
@font-face{font-family:'Montserrat';font-style:normal;font-weight:300;font-display:swap;src:url('../fonts/montserrat-latin-300-normal.woff2') format('woff2')}
@font-face{font-family:'Montserrat';font-style:normal;font-weight:400;font-display:swap;src:url('../fonts/montserrat-latin-400-normal.woff2') format('woff2')}
@font-face{font-family:'Montserrat';font-style:normal;font-weight:500;font-display:swap;src:url('../fonts/montserrat-latin-500-normal.woff2') format('woff2')}
@font-face{font-family:'Montserrat';font-style:normal;font-weight:600;font-display:swap;src:url('../fonts/montserrat-latin-600-normal.woff2') format('woff2')}
@font-face{font-family:'Montserrat';font-style:normal;font-weight:700;font-display:swap;src:url('../fonts/montserrat-latin-700-normal.woff2') format('woff2')}
@font-face{font-family:'Cormorant Garamond';font-style:normal;font-weight:400;font-display:swap;src:url('../fonts/cormorant-garamond-latin-400-normal.woff2') format('woff2')}
@font-face{font-family:'Cormorant Garamond';font-style:normal;font-weight:500;font-display:swap;src:url('../fonts/cormorant-garamond-latin-500-normal.woff2') format('woff2')}
@font-face{font-family:'Cormorant Garamond';font-style:normal;font-weight:600;font-display:swap;src:url('../fonts/cormorant-garamond-latin-600-normal.woff2') format('woff2')}
@font-face{font-family:'Cormorant Garamond';font-style:normal;font-weight:700;font-display:swap;src:url('../fonts/cormorant-garamond-latin-700-normal.woff2') format('woff2')}
@font-face{font-family:'Cormorant Garamond';font-style:italic;font-weight:400;font-display:swap;src:url('../fonts/cormorant-garamond-latin-400-italic.woff2') format('woff2')}
CSS

# 3) 下载字体（服务器连 jsdelivr 很快）
cd assets/fonts
B="https://cdn.jsdelivr.net/npm/@fontsource"
for w in 300 400 500 600 700; do curl -s -m 30 -o montserrat-latin-$w-normal.woff2 "$B/montserrat/files/montserrat-latin-$w-normal.woff2"; done
for w in 400 500 600 700; do curl -s -m 30 -o cormorant-garamond-latin-$w-normal.woff2 "$B/cormorant-garamond/files/cormorant-garamond-latin-$w-normal.woff2"; done
curl -s -m 30 -o cormorant-garamond-latin-400-italic.woff2 "$B/cormorant-garamond/files/cormorant-garamond-latin-400-italic.woff2"

# 4) 版本号 + 权限
sed -i "s/'1.4.1'/'1.4.2'/" /root/luckmall/theme/vinexus/functions.php
docker exec lm_wp chown -R 33:33 /var/www/html/wp-content/themes/vinexus

echo "==== 完成 ===="
echo "字体文件数: $(ls /root/luckmall/theme/vinexus/assets/fonts/*.woff2 2>/dev/null | wc -l) （应为 10）"
echo "残留 Google 字体: $(grep -c fonts.googleapis /root/luckmall/theme/vinexus/functions.php) （应为 0）"
