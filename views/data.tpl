<!DOCTYPE html>
<html>

<head>
  <!-- Standard Meta -->
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

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
    .Rtable--2cols > .Rtable-cell  { width: 50%; }
    .Rtable--3cols > .Rtable-cell  { width: 33.33%; }
    .Rtable--4cols > .Rtable-cell  { width: 25%; }
    .Rtable--5cols > .Rtable-cell  { width: 20%; }
    .Rtable--6cols > .Rtable-cell  { width: 16.6%; }
    .Rtable--7cols > .Rtable-cell  { width: 14.28%; }
  </style>
  
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js" integrity="sha256-c0m8xzX5oOBawsnLVpHnU2ieISOvxi584aNElFl2W6M="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js" integrity="sha256-Bhi6GMQ/72uYZcJXCJ2LToOIcN3+Cx47AZnq/Bw1f7A="
    crossorigin="anonymous"></script>
  <script src="/js/app.js"></script>
</head>

<body onload="initData()">
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
    % if data['cookie'][1] == '2':
    <div class="ui stackable two column vertically divided grid container">
      <div class="column">
        <div class="ui attached message">
          <div class="header">
            ¿Cómo cargar archivos?
          </div>
          <ol class="list">
            <li>Seleccione el tipo de archivo que va a cargar en la base de datos.
              <ul class="list">
                <li>
                  <strong>Canal endémico:</strong> contiene la información de casos por semanas.
                  <a title="Descargar plantilla para el ejemplo 1" href="/plantillas/ejemplo1.xlsx"><small>(Ejemplo 1)</small></a>
                </li>
                <li>
                  <strong>Georreferenciación:</strong> contiene los casos geoposicionados.
                  <a title="Descargar plantilla para el ejemplo 2" href="/plantillas/ejemplo2.xlsx"><small>(Ejemplo 2)</small></a>
                </li>
                <li>
                    <strong>Parámetros de simulación:</strong> contiene los parámetros para el modelo matemático.
                    <a title="Descargar plantilla para el ejemplo 3" href="/plantillas/ejemplo3.xlsx"><small>(Ejemplo 3)</small></a>
                  </li>
                  <li>
                    <strong>Polígonos de comunas:</strong> contiene los vértices de cada comuna.
                    <a title="Descargar plantilla para el ejemplo 4" href="/plantillas/ejemplo4.xlsx"><small>(Ejemplo 4)</small></a>
                  </li>

                  <li>
                    <strong> Prediccion: </strong> contiene los parametros para el modelo matematico que predice futuras epidemias de dengue.
                    <a title="Descargar plantilla para el ejemplo 5" href="/plantillas/ejemplo4.xlsx"><small>(Ejemplo 5)</small></a>
                  </li>
              </ul>
            </li>
            <li>Presione el botón de escoger archivo.</li>
            <li>Presione el botón de Cargar para subir el archivo a la nube.</li>
          </ol>
        </div>
        <form class="ui form attached fluid segment" method="post" action="/datos/cargar" enctype="multipart/form-data">
          <div class="field">
            <select name="datatype" class="ui dropdown">
              <option selected value="cecps">Casos por semana</option>
              <option value="geopos">Georreferenciación</option>
              <option value="params">Parámetros de simulación</option>
              <option value="layers">Polígonos de comunas</option>
              <option value="predict"> Prediccion </option>
            </select>
          </div>
          <div class="field">
            <div class="ui input">
              <input type="file" accept=".xlsx, application/vnd.ms-excel" name="datafile">
            </div>
          </div>
          <input class="ui fluid large teal button" type="submit" value="Cargar" onclick="this.disabled=true;document.forms[0].submit()"></input>
          {{!error_msg}}
        </form>
        <div class="ui bottom attached warning message">
          <i class="attention icon"></i> Recuerde que los datos se sobreescriben automáticamente.
        </div>
      </div>
      <div id="ejemplo1" class="column">
        <div class="ui message">
          <div class="header">Ejemplo 1 <a title="Descargar plantilla para el ejemplo 1" href="/plantillas/ejemplo1.xlsx"><i class="icon download"></i></a></div>
          <ul class="list">
            <li>La primera columna [A] lleva el año correspondiente.</li>
            <li>La segunda columna [B] es la población.</li>
            <li>El sistema lee automáticamente 52 semanas en el rango [C:BB].</li>
            <li>La primera fila no es tomada en cuenta pues contiene los títulos de cada columna.</li>
            <li>Las semanas deben ser ingresadas en orden ascendente (s1, ... , s52).</li>
            <li>Todas las semanas faltantes son reemplazadas por ceros.</li>
          </ul>
        </div>
        <div class="Rtable Rtable--7cols">
          <div style="order:1;" class="Rtable-cell"><h3></h3></div>
          <div style="order:2;" class="Rtable-cell center"><strong>1</strong></div>
          <div style="order:3;" class="Rtable-cell center"><strong>2</strong></div>
          <div style="order:4;" class="Rtable-cell center"><strong>3</strong></div>
          <div style="order:5;" class="Rtable-cell center"><strong>4</strong></div>

          <div style="order:1;" class="Rtable-cell center"><strong>A</strong></div>
          <div style="order:2;" class="Rtable-cell">Año</div>
          <div style="order:3;" class="Rtable-cell">2017</div>
          <div style="order:4;" class="Rtable-cell">2016</div>
          <div style="order:5;" class="Rtable-cell">2018</div>

          <div style="order:1;" class="Rtable-cell center"><strong>B</strong></div>
          <div style="order:2;" class="Rtable-cell">Población</div>
          <div style="order:3;" class="Rtable-cell">420000</div>
          <div style="order:4;" class="Rtable-cell">410000</div>
          <div style="order:5;" class="Rtable-cell">450000</div>

          <div style="order:1;" class="Rtable-cell center"><strong>C</strong></div>
          <div style="order:2;" class="Rtable-cell">s1</div>
          <div style="order:3;" class="Rtable-cell">10</div>
          <div style="order:4;" class="Rtable-cell">7</div>
          <div style="order:5;" class="Rtable-cell">14</div>

          <div style="order:1;" class="Rtable-cell center"><strong>D</strong></div>
          <div style="order:2;" class="Rtable-cell">s2</div>
          <div style="order:3;" class="Rtable-cell">12</div>
          <div style="order:4;" class="Rtable-cell">9</div>
          <div style="order:5;" class="Rtable-cell"></div>

          <div style="order:1;" class="Rtable-cell center"><strong>BA</strong></div>
          <div style="order:2;" class="Rtable-cell">s51</div>
          <div style="order:3;" class="Rtable-cell">5</div>
          <div style="order:4;" class="Rtable-cell">6</div>
          <div style="order:5;" class="Rtable-cell"></div>

          <div style="order:1;" class="Rtable-cell center"><strong>BB</strong></div>
          <div style="order:2;" class="Rtable-cell">s52</div>
          <div style="order:3;" class="Rtable-cell">3</div>
          <div style="order:4;" class="Rtable-cell">5</div>
          <div style="order:5;" class="Rtable-cell"></div>
        </div>
      </div>
      <div id="ejemplo2" class="column" style="display:none;">
        <div class="ui message">
          <div class="header">Ejemplo 2 <a title="Descargar plantilla para el ejemplo 2" href="/plantillas/ejemplo2.xlsx"><i class="icon download"></i></a></div>
          <ul class="list">
            <li>La primera columna [A] lleva el año correspondiente.</li>
            <li>La segunda columna [B] hace referencia a la semana.</li>
            <li>La tercera columna [C] es la <a href="https://es.wikipedia.org/wiki/Longitud_(cartograf%C3%ADa)">longitud</a>.</li>
            <li>La cuarta columna [D] es la <a href="https://es.wikipedia.org/wiki/Latitud">latitud</a>.</li>
            <li>El sistema lee automáticamente todas las filas.</li>
            <li>La primera fila no es tomada en cuenta pues contiene los títulos de cada columna.</li>
          </ul>
        </div>
        <div class="Rtable Rtable--5cols">
          <div style="order:1;" class="Rtable-cell"><h3></h3></div>
          <div style="order:2;" class="Rtable-cell center"><strong>1</strong></div>
          <div style="order:3;" class="Rtable-cell center"><strong>2</strong></div>
          <div style="order:4;" class="Rtable-cell center"><strong>3</strong></div>
          <div style="order:5;" class="Rtable-cell center"><strong>4</strong></div>

          <div style="order:1;" class="Rtable-cell center"><strong>A</strong></div>
          <div style="order:2;" class="Rtable-cell">Año</div>
          <div style="order:3;" class="Rtable-cell">2011</div>
          <div style="order:4;" class="Rtable-cell">2011</div>
          <div style="order:5;" class="Rtable-cell">2012</div>

          <div style="order:1;" class="Rtable-cell center"><strong>B</strong></div>
          <div style="order:2;" class="Rtable-cell">Semana</div>
          <div style="order:3;" class="Rtable-cell">43</div>
          <div style="order:4;" class="Rtable-cell">11</div>
          <div style="order:5;" class="Rtable-cell">5</div>

          <div style="order:1;" class="Rtable-cell center"><strong>C</strong></div>
          <div style="order:2;" class="Rtable-cell">Latitud</div>
          <div style="order:3;" class="Rtable-cell">-75.567653</div>
          <div style="order:4;" class="Rtable-cell">-75.571211</div>
          <div style="order:5;" class="Rtable-cell">-75.544677</div>

          <div style="order:1;" class="Rtable-cell center"><strong>D</strong></div>
          <div style="order:2;" class="Rtable-cell">Longitud</div>
          <div style="order:3;" class="Rtable-cell">6.353137</div>
          <div style="order:4;" class="Rtable-cell">6.356455</div>
          <div style="order:5;" class="Rtable-cell">6.306948</div>
        </div>
      </div>
      <div id="ejemplo3" class="column" style="display:none;">
        <div class="ui message">
            <div class="header">Ejemplo 3 <a title="Descargar plantilla para el ejemplo 3" href="/plantillas/ejemplo3.xlsx"><i class="icon download"></i></a></div>
            <ul class="list">
              <li>La primera columna [A] lleva el nombre del parámetro.</li>
              <li>La segunda columna [B] es el valor del parámetro.</li>
              <li>La primera fila no es tomada en cuenta pues contiene los títulos de cada columna.</li>
              <li>Los datos experimentales del modelo se cargan en la variable <strong>Hi_exp</strong> separados por comas.</li>
            </ul>
        </div>
        <div class="Rtable Rtable--3cols">
          <div style="order:1" class="Rtable-cell"><h3></h3></div>
          <div style="order:2" class="Rtable-cell center"><strong>1</strong></div>
          <div style="order:3" class="Rtable-cell center"><strong>2</strong></div>
          <div style="order:4" class="Rtable-cell center"><strong>3</strong></div>
          <div style="order:5" class="Rtable-cell center"><strong>4</strong></div>
          <div style="order:6" class="Rtable-cell center"><strong>5</strong></div>
          <div style="order:7" class="Rtable-cell center"><strong>6</strong></div>
          <div style="order:8" class="Rtable-cell center"><strong>7</strong></div>
          <div style="order:9" class="Rtable-cell center"><strong>8</strong></div>
          
          <div style="order:1" class="Rtable-cell center"><strong>A</strong></div>
          <div style="order:2" class="Rtable-cell">Parámetro</div>
          <div style="order:3" class="Rtable-cell">A_c1</div>
          <div style="order:4" class="Rtable-cell">alpha</div>
          <div style="order:5" class="Rtable-cell">mu_m</div>
          <div style="order:6" class="Rtable-cell">C</div>
          <div style="order:7" class="Rtable-cell">Hi0</div>
          <div style="order:8" class="Rtable-cell">gamma_p</div>
          <div style="order:9" class="Rtable-cell">Hi_exp</div>

          <div style="order:1" class="Rtable-cell center"><strong>B</strong></div>
          <div style="order:2" class="Rtable-cell">Valor</div>
          <div style="order:3" class="Rtable-cell">6.4903</div>
          <div style="order:4" class="Rtable-cell">1.0007</div>
          <div style="order:5" class="Rtable-cell">0.38475</div>
          <div style="order:6" class="Rtable-cell">144413.9935</div>
          <div style="order:7" class="Rtable-cell">8</div>
          <div style="order:8" class="Rtable-cell">2.9749</div>
          <div style="order:9" class="Rtable-cell">8, 4, 8, 6, 18, 13, 15</div>
        </div>
      </div>

      <div id="ejemplo5" class="column" style="display:none;">
        <div class="ui message">
            <div class="header">Ejemplo 5 <a title="Descargar plantilla para el ejemplo 5" href="/plantillas/ejemplo5.xlsx"><i class="icon download"></i></a></div>
            <ul class="list">
              <li>La primera columna [A] lleva la semana.</li>
              <li>La segunda columna [B] es el numero de casos de contagiados con denge en esa semana.</li>
              <li>La tercera columna [C] es la temperatura de dicha semana. </li>
              <li>La cuarta columna [D] es el numero de busquedas de la palabra <strong>dengue</strong>.</li>
              <li>El modelo matematico predice los numeros de casos de dengue gracias a paremetros como el numero de busquedas y la temperatura</li>
              <li>Debe ingresar un archivo con mas de 99 filas con las semanas ordenadas de manera ascendente</li>
              <li>El numero de busquedas de la palabra <strong>dengue</strong> las puede encontrar en https://trends.google.es/trends/explore?geo=CO&q=dengue.</li>
            </ul>
        </div>

        <div class="Rtable Rtable--5cols">
          <div style="order:1" class="Rtable-cell"><h3></h3></div>
            <div style="order:2" class="Rtable-cell center"><strong>1</strong></div>
            <div style="order:3" class="Rtable-cell center"><strong>2</strong></div>
            <div style="order:4" class="Rtable-cell center"><strong>3</strong></div>
            <div style="order:5" class="Rtable-cell center"><strong>4</strong></div>
            <div style="order:6" class="Rtable-cell center"><strong>5</strong></div>
            <div style="order:7" class="Rtable-cell center"><strong>6</strong></div>

            <div style="order:1" class="Rtable-cell center"><strong>A</strong></div>
            <div style="order:2" class="Rtable-cell">Semana</div>
            <div style="order:3" class="Rtable-cell">1</div>
            <div style="order:4" class="Rtable-cell">2</div>
            <div style="order:5" class="Rtable-cell">3</div>
            <div style="order:6" class="Rtable-cell">4</div>
            <div style="order:7" class="Rtable-cell">5</div>

            <div style="order:1" class="Rtable-cell center"><strong>B</strong></div>
            <div style="order:2" class="Rtable-cell">Casos</div>
            <div style="order:3" class="Rtable-cell">10</div>
            <div style="order:4" class="Rtable-cell">2</div>
            <div style="order:5" class="Rtable-cell">6</div>
            <div style="order:6" class="Rtable-cell">2</div>
            <div style="order:7" class="Rtable-cell">9</div>

            <div style="order:1" class="Rtable-cell center"><strong>C</strong></div>
            <div style="order:2" class="Rtable-cell">Temperatura</div>
            <div style="order:3" class="Rtable-cell">21.525</div>
            <div style="order:4" class="Rtable-cell">20.85714286</div>
            <div style="order:5" class="Rtable-cell">21.67142857</div>
            <div style="order:6" class="Rtable-cell">22.3</div>
            <div style="order:7" class="Rtable-cell">21.15714286</div>

            <div style="order:1" class="Rtable-cell center"><strong>D</strong></div>
            <div style="order:2" class="Rtable-cell">Busquedas</div>
            <div style="order:3" class="Rtable-cell">0</div>
            <div style="order:4" class="Rtable-cell">11</div>
            <div style="order:5" class="Rtable-cell">0</div>
            <div style="order:6" class="Rtable-cell">10</div>
            <div style="order:7" class="Rtable-cell">0</div>

        </div>


      </div>
    </div>
    <br>
    <br>
    % end
    <table class="ui celled table">
      <thead>
        <tr>
          <th colspan="2">
            <h4>
              <i class="bar chart icon"></i>Base de datos para el módulo de canal endémico</h4>
          </th>
        </tr>
      </thead>
      <tbody>
        % for n in data['cases']:
        <tr id="{{data['cases'][n]['_id']}}" data-year="{{data['cases'][n]['year']}}">
          <td>
            <div class="chart-container">
              <canvas id="chart-{{data['cases'][n]['year']}}" data-year="{{data['cases'][n]['year']}}">{{data['cases'][n]['data']}}</canvas>
            </div>
          </td>
          <td class="center aligned collapsing">
            <h5 title="Población para el año {{data['cases'][n]['year']}}">{{data['cases'][n]['population']}}<i class="icon child"></i></h5>
            <br>
            % if data['cookie'][1] == '2':
            <button title="Eliminar conjunto de datos del año {{data['cases'][n]['year']}}" class="ui icon button" onclick='removeDataYear("{{data['cases'][n]['_id']}}")'>
              <i class="trash icon"></i>
            </button>
            % end
            <button title="Descargar conjunto de datos del año {{data['cases'][n]['year']}}" class="ui icon button" onclick='downloadDataYear("{{data['cases'][n]['_id']}}")'>
              <i class="download icon"></i>
            </button>
          </td>
        </tr>
        % end
      </tbody>
    </table>
  </div>
  <br>
</body>

</html>