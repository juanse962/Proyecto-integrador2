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
  <style>
    .Rtable {
      display: flex; 
      flex-wrap: wrap;
      margin: 0 0 3em 0;
      padding: 0;
    }
    .Rtable-cell {
      box-sizing: border-box;
      flex-grow: 1;
      width: 100%;
      padding: 0.2em 0.8em;
      overflow: hidden;
      list-style: none;
      border: solid 1px rgba(112, 128, 144, 0.2);
      background: white;
    }
    .Rtable-cell.center {
      text-align: center;
      background: #f8f8f9 !important;
    }
    /* Table column sizing
    ================================== */
    .Rtable--3cols > .Rtable-cell  { width: 30%; }
  </style>
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js" integrity="sha256-c0m8xzX5oOBawsnLVpHnU2ieISOvxi584aNElFl2W6M="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js" integrity="sha256-Bhi6GMQ/72uYZcJXCJ2LToOIcN3+Cx47AZnq/Bw1f7A="
    crossorigin="anonymous"></script>
  <script src="/js/app.js"></script>
</head>

<body onload="initPrediction()">
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
          <h2 class="ui header">Predicción</h2>
          <p style="text-align:justify">
            La prediccion estadistica es una herramienta que ayuda a predecir los casos de dengue en un tiempo futuro.
          <br><br>
            Hay varias metodologias para calcularlo, y para todas ellas se necesitan tener los casos anteriores,
            la temperatura promedio y las busquedas de la palabra dengue en Google. La grafica muestra los caos
            y la prediccion con el metodo seleccionado. 
          </p>
        </div>
      </div>
      <div class="column">
        <div class="ui attached message">
          <div class="header">
            Seleccion de algoritmo
          </div>
          <p> Selecciona el algoritmo que deseas aplicar a tus datos </p>
        </div>

        <form class="ui form attached fluid segment" method="post" action="" enctype="multipart/form-data">
          <div class="field">
            <select id="predictionMethod" class="ui dropdown">
              <option selected value="r_lineal">Regresion lineal</option>
              <option value="svm">maquina de soporte vectorial (lineal)</option>
              <option value="kn">K vecinos mas cercanos (lineal)</option>
            </select>
          </div>
          <div class="six wide field">
            <div class="ui blue submit button" onclick="makePrediction()">Construir grafica</div>
          </div>
        </form>

        <div class="ui attached message">
          <div class="header">
            Metricas de evaluacion
          </div>
          <p> Some description heree </p>
        </div>
        <div class="Rtable Rtable--3cols">
          <div style="order:1;" class="Rtable-cell center"><strong>R^2</strong></div>
          <div id="r2" style="order:2;" class="Rtable-cell">1</div>

          <div style="order:1;" class="Rtable-cell center"><strong>MSE</strong></div>
          <div id="mse" style="order:2;" class="Rtable-cell">6.815787431344311</div>

          <div style="order:1;" class="Rtable-cell center"><strong>RMSE</strong></div>
          <div id="rmse" style="order:2;" class="Rtable-cell">2.6107063089026905</div>

        </div>
      </div>
    </div>
    <br>
    <h4 class="ui horizontal divider header">
      <i class="bar chart icon"></i>
      Predicción
    </h4>
    <div class="ui container chart-container">
      <canvas id="chart-pred" style="height:85vh"></canvas>
    </div>
  </div>
</body>

</html>
