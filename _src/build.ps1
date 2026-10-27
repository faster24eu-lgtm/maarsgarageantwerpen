# Builds the static site: wraps every _src/pages/*.html in the shared layout,
# writes <path>/index.html, sitemap.xml and robots.txt into the repo root.
# Run from PowerShell:  & .\_src\build.ps1

$ErrorActionPreference = 'Stop'
$src  = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:\Users\Karim\Documents\maarsgarageantwerpen\_src' }
$root = Split-Path $src -Parent
$site = 'https://maarsgarageantwerpen.be'
$utf8 = New-Object System.Text.UTF8Encoding $false
$today = (Get-Date).ToString('yyyy-MM-dd')

# icons: {{icon:name}} -> inline svg
$icons = @{}
Get-ChildItem "$src\icons\*.svg" | ForEach-Object {
  $svg = [IO.File]::ReadAllText($_.FullName, $utf8)
  $svg = $svg -replace '<!--[\s\S]*?-->', '' -replace '\s+', ' ' -replace '> <', '><'
  $svg = $svg -replace 'class="[^"]*"', 'class="i" aria-hidden="true" focusable="false"'
  $svg = $svg -replace ' width="24" height="24"', '' -replace 'stroke-width="2"', 'stroke-width="1.75"'
  $icons[$_.BaseName] = $svg.Trim()
}
function Expand-Icons([string]$html) {
  return [regex]::Replace($html, '\{\{icon:([a-z0-9-]+)\}\}', { param($m) $n = $m.Groups[1].Value; if (-not $icons.ContainsKey($n)) { throw "Unknown icon $n" }; $icons[$n] })
}

$nav = @'
<header class="site-header">
  <div class="wrap">
    <a class="brand" href="/" aria-label="Maars Garage - home"><img src="/assets/logo-maars-garage.png" width="480" height="240" alt="Logo Garage Maars"></a>
    <nav class="nav" aria-label="Hoofdmenu">
      <a href="/">Home</a>
      <div class="dd">
        <button type="button" aria-expanded="false">Diensten</button>
        <div class="dd-menu">
          <a href="/onderhoud/">Onderhoud &amp; nazicht</a>
          <a href="/herstellingen/">Herstellingen</a>
          <a href="/keuring/">Keuring &amp; herkeuring</a>
          <a href="/diagnose/">Diagnose &amp; foutcodes</a>
          <a href="/batterij/">Batterij testen &amp; vervangen</a>
          <a href="/panne/">Wagen in panne</a>
        </div>
      </div>
      <div class="dd">
        <button type="button" aria-expanded="false">Regio</button>
        <div class="dd-menu">
          <a href="/">Wilrijk</a>
          <a href="/garage-antwerpen/">Antwerpen</a>
          <a href="/garage-hoboken/">Hoboken</a>
          <a href="/garage-berchem/">Berchem</a>
          <a href="/garage-edegem/">Edegem</a>
          <a href="/garage-aartselaar/">Aartselaar</a>
          <a href="/garage-mortsel/">Mortsel</a>
        </div>
      </div>
      <a href="/over-ons/">Over ons</a>
      <a href="/contact/">Contact</a>
    </nav>
    <div class="head-cta">
      <a class="head-phone" href="tel:+32472883917">{{icon:phone}}0472 88 39 17</a>
      <a class="btn btn-wa btn-sm" href="https://wa.me/32472883917" target="_blank" rel="noopener">{{icon:brand-whatsapp}}WhatsApp</a>
    </div>
    <button class="menu-btn" type="button" aria-label="Menu openen" aria-expanded="false">{{icon:menu-2}}</button>
  </div>
</header>
'@

$cta = @'
<section class="cta-band">
  <div class="wrap">
    <div>
      <h2>Afspraak maken bij Maars Garage?</h2>
      <p>Bel of stuur een WhatsApp. Vaak kan uw wagen dezelfde week nog binnen.</p>
    </div>
    <div class="btns">
      <a class="btn btn-line" href="tel:+32472883917">{{icon:phone}}0472 88 39 17</a>
      <a class="btn btn-wa" href="https://wa.me/32472883917" target="_blank" rel="noopener">{{icon:brand-whatsapp}}WhatsApp</a>
    </div>
  </div>
</section>
'@

$footer = @'
<footer class="site-footer">
  <div class="wrap">
    <div class="foot">
      <div>
        <img class="foot-logo" src="/assets/logo-maars-garage.png" width="480" height="240" alt="Garage Maars" loading="lazy">
        <p>Maars Garage BV<br>Michel Willemsplein 8<br>2610 Wilrijk (Antwerpen)</p>
        <p><a href="tel:+32472883917">0472 88 39 17</a><br><a href="https://wa.me/32472883917" target="_blank" rel="noopener">WhatsApp</a></p>
      </div>
      <div>
        <h3>Diensten</h3>
        <ul>
          <li><a href="/onderhoud/">Onderhoud &amp; nazicht</a></li>
          <li><a href="/herstellingen/">Herstellingen</a></li>
          <li><a href="/keuring/">Keuring &amp; herkeuring</a></li>
          <li><a href="/diagnose/">Diagnose &amp; foutcodes</a></li>
          <li><a href="/batterij/">Batterij</a></li>
          <li><a href="/panne/">Wagen in panne</a></li>
        </ul>
      </div>
      <div>
        <h3>Regio</h3>
        <ul>
          <li><a href="/">Garage Wilrijk</a></li>
          <li><a href="/garage-antwerpen/">Garage Antwerpen</a></li>
          <li><a href="/garage-hoboken/">Garage Hoboken</a></li>
          <li><a href="/garage-berchem/">Garage Berchem</a></li>
          <li><a href="/garage-edegem/">Garage Edegem</a></li>
          <li><a href="/garage-aartselaar/">Garage Aartselaar</a></li>
          <li><a href="/garage-mortsel/">Garage Mortsel</a></li>
        </ul>
      </div>
      <div>
        <h3>Openingsuren</h3>
        <table class="hours">
          <tr><td>Maandag - vrijdag</td><td>09:00 - 18:00</td></tr>
          <tr><td>Zaterdag</td><td>09:00 - 16:00</td></tr>
          <tr><td>Zondag</td><td>Gesloten</td></tr>
        </table>
        <p style="margin-top:14px"><a href="/over-ons/">Over ons</a> &middot; <a href="/contact/">Contact</a></p>
      </div>
    </div>
    <div class="foot-bottom">
      <span>&copy; <span id="jaar">2026</span> Maars Garage BV &middot; Wilrijk, Antwerpen</span>
      <span><a href="https://maps.google.com/?cid=2709901805709394667" target="_blank" rel="noopener">Maars Garage op Google Maps</a></span>
    </div>
  </div>
</footer>
<div class="mbar">
  <a class="m-call" href="tel:+32472883917">{{icon:phone}}Bellen</a>
  <a class="m-wa" href="https://wa.me/32472883917" target="_blank" rel="noopener">{{icon:brand-whatsapp}}WhatsApp</a>
</div>
'@

$business = @'
{"@context":"https://schema.org","@type":"AutoRepair","@id":"https://maarsgarageantwerpen.be/#garage","name":"Maars Garage BV","alternateName":"Garage Maars","url":"https://maarsgarageantwerpen.be/","logo":"https://maarsgarageantwerpen.be/assets/logo-maars-garage-512.png","image":"https://maarsgarageantwerpen.be/assets/logo-maars-garage-512.png","telephone":"+32472883917","priceRange":"€€","address":{"@type":"PostalAddress","streetAddress":"Michel Willemsplein 8","postalCode":"2610","addressLocality":"Wilrijk","addressRegion":"Antwerpen","addressCountry":"BE"},"geo":{"@type":"GeoCoordinates","latitude":51.1802794,"longitude":4.375317},"hasMap":"https://maps.google.com/?cid=2709901805709394667","openingHoursSpecification":[{"@type":"OpeningHoursSpecification","dayOfWeek":["Monday","Tuesday","Wednesday","Thursday","Friday"],"opens":"09:00","closes":"18:00"},{"@type":"OpeningHoursSpecification","dayOfWeek":"Saturday","opens":"09:00","closes":"16:00"}],"areaServed":["Wilrijk","Antwerpen","Hoboken","Berchem","Edegem","Aartselaar","Mortsel"]}
'@

$pages = @()
Get-ChildItem "$src\pages\*.html" | ForEach-Object {
  $raw = [IO.File]::ReadAllText($_.FullName, $utf8)
  $m = [regex]::Match($raw, '^\s*<!--meta([\s\S]*?)-->')
  if (-not $m.Success) { throw "No meta block in $($_.Name)" }
  $meta = @{}
  foreach ($line in ($m.Groups[1].Value -split "`n")) {
    $i = $line.IndexOf(':')
    if ($i -gt 0) { $meta[$line.Substring(0, $i).Trim()] = $line.Substring($i + 1).Trim() }
  }
  $body = $raw.Substring($m.Length)
  foreach ($k in 'path', 'title', 'description') { if (-not $meta[$k]) { throw "$($_.Name): missing $k" } }
  if ($meta.title.Length -gt 65) { Write-Warning "$($_.Name): title $($meta.title.Length) chars" }
  if ($meta.description.Length -gt 160) { Write-Warning "$($_.Name): description $($meta.description.Length) chars" }

  $path = $meta.path
  $url = $site + $path
  $robots = if ($meta.noindex) { 'noindex' } else { 'index,follow' }
  $esc = { param($s) $s.Replace('&', '&amp;').Replace('"', '&quot;') }

  $ld = '<script type="application/ld+json">' + $business.Trim() + '</script>'
  if ($meta.crumb) {
    $crumbs = '{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"' + $site + '/"},{"@type":"ListItem","position":2,"name":"' + $meta.crumb + '","item":"' + $url + '"}]}'
    $ld += "`n" + '<script type="application/ld+json">' + $crumbs + '</script>'
  }

  $head = @"
<!doctype html>
<html lang="nl-BE">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$(& $esc $meta.title)</title>
<meta name="description" content="$(& $esc $meta.description)">
<meta name="robots" content="$robots">
<link rel="canonical" href="$url">
<meta property="og:type" content="website">
<meta property="og:locale" content="nl_BE">
<meta property="og:site_name" content="Maars Garage">
<meta property="og:title" content="$(& $esc $meta.title)">
<meta property="og:description" content="$(& $esc $meta.description)">
<meta property="og:url" content="$url">
<meta property="og:image" content="$site/assets/logo-maars-garage-512.png">
<meta name="theme-color" content="#141414">
<link rel="icon" type="image/png" sizes="48x48" href="/assets/favicon-48.png">
<link rel="apple-touch-icon" href="/assets/apple-touch-icon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/assets/style.css">
$ld
</head>
<body>
<a class="skip" href="#inhoud">Naar de inhoud</a>
"@

  $html = $head + "`n" + $nav + "`n<main id=""inhoud"">" + $body.Trim() + "`n</main>`n"
  if (-not $meta.nocta) { $html += $cta + "`n" }
  $html += $footer + "`n<script src=""/assets/site.js"" defer></script>`n</body>`n</html>`n"
  $html = Expand-Icons $html

  if ($path -eq '/404.html') { $out = Join-Path $root '404.html' }
  else {
    $dir = Join-Path $root ($path.Trim('/'))
    New-Item -ItemType Directory -Force $dir | Out-Null
    $out = Join-Path $dir 'index.html'
  }
  [IO.File]::WriteAllText($out, $html, $utf8)
  if (-not $meta.noindex) { $pages += [pscustomobject]@{ url = $url; prio = if ($path -eq '/') { '1.0' } elseif ($path -like '/garage-*') { '0.7' } else { '0.8' } } }
  Write-Host "built $path"
}

$sm = '<?xml version="1.0" encoding="UTF-8"?>' + "`n" + '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + "`n"
foreach ($p in ($pages | Sort-Object prio -Descending)) { $sm += "  <url><loc>$($p.url)</loc><lastmod>$today</lastmod><priority>$($p.prio)</priority></url>`n" }
$sm += '</urlset>' + "`n"
[IO.File]::WriteAllText((Join-Path $root 'sitemap.xml'), $sm, $utf8)
[IO.File]::WriteAllText((Join-Path $root 'robots.txt'), "User-agent: *`nAllow: /`n`nSitemap: $site/sitemap.xml`n", $utf8)
Write-Host "$($pages.Count) pages in sitemap"
