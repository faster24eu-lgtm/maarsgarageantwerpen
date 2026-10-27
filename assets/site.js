(function () {
  var header = document.querySelector('.site-header');
  var menuBtn = document.querySelector('.menu-btn');
  if (menuBtn && header) {
    menuBtn.addEventListener('click', function () {
      var open = header.classList.toggle('open');
      menuBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
  }

  document.querySelectorAll('.dd > button').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var dd = btn.parentElement;
      var open = dd.classList.toggle('open');
      btn.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
  });
  document.addEventListener('click', function (e) {
    document.querySelectorAll('.dd.open').forEach(function (dd) {
      if (!dd.contains(e.target)) dd.classList.remove('open');
    });
  });

  // WhatsApp form: builds the message and opens WhatsApp with it
  var form = document.querySelector('.wa-form');
  if (form) {
    var msg = form.querySelector('[name=bericht]');
    var count = form.querySelector('.count');
    if (msg && count) {
      msg.addEventListener('input', function () { count.textContent = msg.value.length + '/1000'; });
    }
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var v = function (n) { var el = form.querySelector('[name=' + n + ']'); return el ? el.value.trim() : ''; };
      var lines = ['Hallo Maars Garage,', ''];
      if (v('dienst')) lines.push('Onderwerp: ' + v('dienst'));
      if (v('wagen')) lines.push('Wagen: ' + v('wagen'));
      lines.push('', v('bericht'), '', 'Naam: ' + v('naam'));
      if (v('telefoon')) lines.push('Telefoon: ' + v('telefoon'));
      var url = 'https://wa.me/32472883917?text=' + encodeURIComponent(lines.join('\n'));
      window.open(url, '_blank', 'noopener');
    });
  }

  var y = document.getElementById('jaar');
  if (y) y.textContent = new Date().getFullYear();
})();
