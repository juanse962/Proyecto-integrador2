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

<body onload="initSimulator()">
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
          <h2 class="ui header">Modelo matemático para simular la respuesta al control</h2>
          <p style="text-align:justify">
            Este simulador está basado en un modelo matemático de ecuaciones diferenciales.
            Esta herramienta permite simular una epidemia de dengue y una acción de control
            por fumigación. El valor inicial de la fumigación está establecido donde realmente
            ocurrió, pero es posible seleccionar otra semana, otra duración y otra intensidad
            de fumigación para ver, por ejemplo, qué hubiera pasado si la fumigación se hubiera
            hecho antes o después de la fecha en la que realmente ocurrió.
            <br><br>
            Al presionar Simular se obtiene en la parte inferior de la pantalla la gráfica de la
            salida del modelo con los parámetros escogidos, adicionalmente se muestra sobre la misma
            gráfica la acción de control por fumigación realizada.
            </p>
        </div>
      </div>
      <div class="column">
        <div class="ui attached message">
          <div class="header">
            Parámetros del pulso de control
          </div>
          <div>Cambia los parámetros y luego presionar Simular.&nbsp;
            <div class="ui compact icon buttons">
              <button class="ui button remPulse" data-inverted="" data-tooltip="Elimina un pulso de control">
                <i class="minus icon"></i>
              </button>
              <button class="ui compact labeled icon button addPulse" data-inverted="" data-tooltip="Agrega un pulso de control">
                <i class="plus icon"></i>
                Pulso
              </button>
            </div>
          </div>
          <p>
            <strong>Intensidad [n]:</strong> es la tasa de mosquitos que mueren por semana.<br>
            <strong>Semana inicial [n]:</strong> es la semana en la cual inicia la acción de control.<br>
            <strong>Duración [n]:</strong> es cuánto se prolonga la acción de fumigación incluyendo el efecto residual.<br>
          </p>
        </div>
        <form class="ui form attached fluid segment" onsubmit="return false;">
          <div class="pulses">
            % number_c = 1
            % while True:
            % try:
            <div class="three fields" data-pulse="{{!number_c}}">
              <div class="field">
                <label>Intensidad {{!number_c}}</label>
                <input class="simParam" data-param="A_c{{!number_c}}" type="text" value="{{!data['A_c'+str(number_c)]}}"/>
              </div>
              <div class="field">
                <label>Semana inicial {{!number_c}}</label>
                <input class="simParam" data-param="t0_c{{!number_c}}" type="text" value="{{!data['t0_c'+str(number_c)]}}"/>
              </div>
              <div class="field">
                <label>Duración {{!number_c}}</label>
                <input class="simParam" data-param="dt_c{{!number_c}}" type="text" value="{{!data['dt_c'+str(number_c)]}}"/>
              </div>
            </div>
            % except Exception:
            %   break
            % end
            % number_c += 1
            % end
            % end
          </div>
          <div class="three fields">
            <div class="six wide field">
                <div class="ui button fluid" onclick="resetParams({{!number_c-1}})" data-position="bottom center" data-tooltip="Reestablece todos los parámetros a su configuración inicial">Reestablecer</div>
              </div>
            <div class="six wide field">
              <div class="ui teal button fluid" onclick="toggleParams()" data-position="bottom center" data-tooltip="Muestra todos los parámetros del modelo">Opciones avanzadas</div>
            </div>
            <div class="four wide field">
              <div id="btnSim" class="ui blue submit button fluid" onclick="makeSimulation()">Simular</div>
            </div>
          </div>
        </form>
        <div class="ui bottom attached info message">
          <i class="icon info"></i>
          Para ver el significado de cada parámetro, coloque el mouse sobre el cuadro de texto correspondiente.
        </div>
      </div>
    </div>
    <br>
    <div class="ui container simParams" style="display:none">
      <form class="ui form fluid segment" onsubmit="return false;">
        <h4>Condiciones iniciales</h4>
        <div class="five fields">
          <div class="field" data-inverted="" data-tooltip="Número de huevos">
            <label>E0</label>
            <input class="simParam" data-param="E0" type="number" value="{{!data['E0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de larvas iniciales">
            <label>L0</label>
            <input class="simParam" data-param="L0" type="number" value="{{!data['L0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de pupas">
            <label>P0</label>
            <input class="simParam" data-param="P0" type="number" value="{{!data['P0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de mosquitos susceptibles de transmitir el virus">
            <label>Ms0</label>
            <input class="simParam" data-param="Ms0" type="number" value="{{!data['Ms0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de mosquitos expuestos(infectados pero no infecciosos)">
            <label>Me0</label>
            <input class="simParam" data-param="Me0" type="number" value="{{!data['Me0']}}"/>
          </div>
        </div>
        <div class="five fields">
          <div class="field" data-inverted="" data-tooltip="Número de mosquitos infecciosos">
            <label>Mi</label>
            <input class="simParam" data-param="Mi0" type="number" value="{{!data['Mi0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de humanos susceptibles de contraer el virus">
            <label>Hs</label>
            <input class="simParam" data-param="Hs0" type="number" value="{{!data['Hs0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de humanos expuestos(infectados pero no infecciosos)">
            <label>He</label>
            <input class="simParam" data-param="He0" type="number" value="{{!data['He0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de humanos infectados e infecciosos">
            <label>Hi</label>
            <input class="simParam" data-param="Hi0" type="number" value="{{!data['Hi0']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Número de humanos recuperados">
            <label>Hr</label>
            <input class="simParam" data-param="Hr0" type="number" value="{{!data['Hr0']}}"/>
          </div>
        </div>
        <br>
        <h4>Parámetros del modelo</h4>
        <div class="nine fields">
          <div class="field alphaTooltip" data-inverted="" data-tooltip="Incremento de la tasa de mortalidad en mosquitos expuestos e infectados">
            <label>&alpha;</label>
            <input class="simParam" data-param="alpha" type="number" value="{{!data['alpha']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de ovisposión por mosquito">
            <label>&delta;</label>
            <input class="simParam" data-param="delta" type="number" value="{{!data['delta']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Capacidad total de huevos">
            <label>C</label>
            <input class="simParam" data-param="C" type="number" value="{{!data['C']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de transformación de huevo a larva (indicativo del efecto del control mecánico)">
            <label>&gamma;<sub>e</sub></label>
            <input class="simParam" data-param="gamma_e" type="number" value="{{!data['gamma_e']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de mortalidad de huevos">
            <label>&mu;<sub>e</sub></label>
            <input class="simParam" data-param="mu_e" type="number" value="{{!data['mu_e']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de transformación de larva a pupa">
            <label>&gamma;<sub>l</sub></label>
            <input class="simParam" data-param="gamma_l" type="number" value="{{!data['gamma_l']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de mortalidad de larvas">
            <label>&mu;<sub>l</sub></label>
            <input class="simParam" data-param="mu_l" type="number" value="{{!data['mu_l']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de eclosión de pupa a mosquito">
            <label>&gamma;<sub>p</sub></label>
            <input class="simParam" data-param="gamma_p" type="number" value="{{!data['gamma_p']}}"/>
          </div>
          <div class="field" data-inverted="" data-tooltip="Tasa de mortalidad de pupas">
            <label>&mu;<sub>p</sub></label>
            <input class="simParam" data-param="mu_p" type="number" value="{{!data['mu_p']}}"/>
          </div>
        </div>
        <div class="nine fields">
            <div class="field" data-inverted="" data-tooltip="Fracción de hembras que emergen de todos los huevos">
                <label>&#402;</label>
                <input class="simParam" data-param="f" type="number" value="{{!data['f']}}"/>
              </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de contacto efectiva (o coeficiente de transmisión humano-mosquito)">
              <label>&beta;<sub>m</sub></label>
              <input class="simParam" data-param="beta_m" type="number" value="{{!data['beta_m']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de mortalidad de mosquitos">
              <label>&mu;<sub>m</sub></label>
              <input class="simParam" data-param="mu_m" type="number" value="{{!data['mu_m']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de incubación extrínseca (en el tiempo 1/&theta;_m se vuelve infeccioso)">
              <label>&theta;<sub>m</sub></label>
              <input class="simParam" data-param="theta_m" type="number" value="{{!data['theta_m']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de mortalidad de humanos">
              <label>&mu;<sub>h</sub></label>
              <input class="simParam" data-param="mu_h" type="number" value="{{!data['mu_h']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de contacto efectiva (o coeficiente de transmisión mosquito-humano)">
              <label>&beta;<sub>h</sub></label>
              <input class="simParam" data-param="beta_h" type="number" value="{{!data['beta_h']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de incubacion intrínseca (en el tiempo 1/&theta;_h se evidencian los síntomas de la enfermedad)">
              <label>&theta;<sub>h</sub></label>
              <input class="simParam" data-param="theta_h" type="number" value="{{!data['theta_h']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tasa de recuperación">
              <label>&gamma;<sub>h</sub></label>
              <input class="simParam" data-param="gamma_h" type="number" value="{{!data['gamma_h']}}"/>
            </div>
            <div class="field" data-inverted="" data-tooltip="Tiempo de simulación">
                <label>tMax</label>
                <input class="simParam" data-param="tMax" type="number" value=""/>
            </div>
          </div>

      </form>
    </div>
    <h4 class="ui horizontal divider header">
      <i class="bar chart icon"></i>
      Gráfica
    </h4>
    <div class="ui container chart-container">
      <canvas id="chart-sim" class="fullscreenChart">{{data['Hi_exp'] if 'Hi_exp' in data else ''}}</canvas>
    </div>
  </div>
</body>

</html>