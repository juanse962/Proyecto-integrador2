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

  <!-- MAPBOX -->
  <script src='https://api.mapbox.com/mapbox-gl-js/v0.42.0/mapbox-gl.js'></script>
  <link href='https://api.mapbox.com/mapbox-gl-js/v0.42.0/mapbox-gl.css' rel='stylesheet' />
  <link rel="stylesheet" type="text/css" href="/css/main.css">

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js" integrity="sha256-Bhi6GMQ/72uYZcJXCJ2LToOIcN3+Cx47AZnq/Bw1f7A="
    crossorigin="anonymous"></script>
  <script src="/js/range.js"></script>
  <script src="/js/app.js"></script>
</head>

<body onload="initMap()">
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
  <div id="map-containter">
    <div id="map"></div>
    <div id='state-legend' class='legend'>
      <h4>Comunas</h4>
    </div>
    <div id='map-overlay'>
      <div class='map-overlay-inner'>
        <h3>Casos de dengue por semana</h3>
        <label>Seleccione un año y semana</label>
        <br>
        <div id='slider' class="ui range"></div>
        <br>
        <label>Año: </label>
        <select id="year" class="ui dropdown compact" style="min-width:7em;">
          <option class="item" value="0">Todos</option>
        </select>
        <label>Semana: </label>
        <select id="week" class="ui dropdown compact" style="min-width:7em;">
          <option class="item" value="0">Todas</option>
          % for week in range(1,53):
          <option class="item" value="{{week}}">{{week}}</option>
          % end 
        </select>
      </div>
    </div>
  </div>
</body>

</html>
