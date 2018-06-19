<!DOCTYPE html>
<html>

<head>
  <!-- Standard Meta -->
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />

  <!-- Site Properties -->
  <title>{{title}}</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" integrity="sha256-/Z28yXtfBv/6/alw+yZuODgTbKZm86IKbPE/5kjO/xY="
    crossorigin="anonymous" />
  <link rel="stylesheet" type="text/css" href="/css/main.css">
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js" integrity="sha256-c0m8xzX5oOBawsnLVpHnU2ieISOvxi584aNElFl2W6M="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js" integrity="sha256-Bhi6GMQ/72uYZcJXCJ2LToOIcN3+Cx47AZnq/Bw1f7A="
    crossorigin="anonymous"></script>
  <script src="/js/app.js"></script>
</head>

<body onload="initChannel()">
  <div class="ui fixed inverted menu">
    <div class="ui container">
      <a href="/" class="header item">
        {{title}}
      </a>
      <div class="right menu">
        <div class="item">
          <a href="/" class="ui button">Atrás</a>
        </div>
      </div>
    </div>
  </div>
  <div class="ui main container">
    <div class="ui stackable two column vertically divided grid container">
      <div class="column">
        <div class="ui raised very padded segment">
          <h2 class="ui header">¿Qué es el canal endémico?</h2>
          <p style="text-align:justify">El canal endémico es una herramienta que ayuda a detectar la presencia atípica de casos de una enfermedad en una
            región y tiempo determinado. Hay varias metodologías para calcularlo y en todas ellas se logra establecer un
            límite inferior, un promedio y un límite superior. La región que se encuentra por debajo del límite inferior
            se denomina, zona de éxito, la región comprendida entre la media y el límite inferior, se denomina, zona de seguridad,
            la región comprendida entre el límite superior y la media, se denomina, zona de alerta, y finalmente la región
            por encima del límite superior se denomina zona epidémica.</p>
        </div>
      </div>
      <div class="column">
        <div class="ui attached message">
          <div class="header">
            Parámetros de configuración
          </div>
          <p>Selecciona los años para crear el canal y el año actual a comparar.</p>
        </div>
        <form class="ui form attached fluid segment" onsubmit="return false;">
          <div class="two fields">
            <div class="field">
              <label>Año base</label>
              <select id="channelYear" class="ui dropdown">
                % for n in data['channels']:
                <option {{ 'selected' if n==1 else ''}} value="{{data['channels'][n]}}">{{data['channels'][n]}}</option>
                % end
              </select>
            </div>
            <div class="field">
              <label>Años anteriores</label>
              <select id="channelYears" class="ui dropdown">
                <option value="3">3 años</option>
                <option selected value="5">5 años</option>
                <option value="7">7 años</option>
              </select>
            </div>
          </div>
          <div class="two fields">
            <div class="ten wide field">
              <select id="channelMethod" class="ui dropdown">
                <option selected value="mc">Método de los cuartiles</option>
                <option value="mpm">Método de los promedios móviles</option>
                <option value="mic">Método de los intervalos de confianza</option>
              </select>
            </div>
            <div class="six wide field">
              <div class="ui blue submit button" onclick="makeChannel()">Construir canal</div>
            </div>
          </div>
        </form>
        <div class="ui bottom attached warning message">
          <i class="icon info"></i>
          ¿Hacen falta datos? Abre el
          <a href="/datos/">módulo de datos</a>.
        </div>
      </div>
    </div>
    <h4 class="ui horizontal divider header">
      <i class="bar chart icon"></i>
      Canal endémico {{!data['user']}}
    </h4>
    <div class="ui container chart-container">
      <canvas id="chart-channel" class="fullscreenChart"</canvas>
    </div>
  </div>
</body>

</html>