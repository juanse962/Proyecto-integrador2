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
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
    crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js" integrity="sha256-Bhi6GMQ/72uYZcJXCJ2LToOIcN3+Cx47AZnq/Bw1f7A="
    crossorigin="anonymous"></script>
</head>

<body>
  <div class="ui fixed inverted menu">
    <div class="ui container">
      <a href="/" class="header item">
        {{title}}
      </a>
      <div class="right menu">
        <div class="item">
          <a href="/salir" class="ui red button">Salir</a>
        </div>
      </div>
    </div>
  </div>

  <div class="ui main container">
    <div class="ui stackable three column vertically divided grid container">
      <div class="row">
        % if data['cookie'][1] == '2':
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Datos para procesamiento en cada módulo
              </div>
              <div class="description">
                <p>Módulo de administración de bases de datos</p>
                <ul>
                  <li>Cargar archivos en la plataforma.</li>
                  <li>Modificar o eliminar los archivos existentes.</li>
                </ul>
              </div>
            </div>
            <div class="ui three bottom attached buttons">
              <a class="ui button" href="datos/">Abrir</a>
            </div>
          </div>
        </div>
        % else:
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Base de datos
              </div>
              <div class="description">
                <p>Escoja un perfil para ver los datos</p>
                <select id="newUser" class="ui dropdown">
                  <option value=""></option>
                  % for user in data['users']:
                    <option {{'selected' if data['user']==user else ''}} value="{{user}}">{{user}}</option>
                  % end
                </select>
              </div>
            </div>
            <div class="ui three bottom attached buttons">              
              <a class="ui button {{'' if data['modules']['data'] else 'disabled'}}" href="/datos/">Ver datos</a>
            </div>
          </div>
        </div>
        <script type="text/javascript">
          window.onload=function(){
            $('.dropdown').dropdown()
            $(".dropdown").on("input change", function(){
              var newUser = $("#newUser").val();
              $.post('/usuarios/cambiar',{newUser:newUser}).done(function(){window.location.reload()});
            });
          };
        </script>
        % end
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Simulador para el control de la enfermedad
              </div>
              <div class="description">
                <p>Módulo de simulación del modelo matemático para el control</p>
                <ul>
                  <li>Cambiar los parámetros del modelo.</li>
                  <li>Gráficar la respuesta temporal del modelo.</li>
                </ul>
              </div>
            </div>
            <div class="ui three bottom attached buttons">
              <a class="ui button {{'' if data['modules']['sim'] else 'disabled'}}" href="simulador/">Abrir</a>
            </div>
          </div>
        </div>
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Canal endémico
              </div>
              <div class="description">
                <p>Módulo para el análisis del canal endémico</p>
                <ul>
                  <li>Método de los cuartiles.</li>
                  <li>Método de los promedios móviles.</li>              
                  <li>Método de los intervalos de confianza.</li>
                </ul>
              </div>
            </div>
            <div class="ui three bottom attached buttons">
              <a class="ui button {{'' if data['modules']['data'] else 'disabled'}}" href="canal/">Abrir</a>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Mapa de riesgo
              </div>
              <div class="description">
                <p>Módulo de mapa de riesgo</p>
                <ul>
                  <li>Vista de riesgo por comunas.</li>
                </ul>
              </div>
            </div>
            <div class="ui three bottom attached buttons">
              <a class="ui button {{'' if data['modules']['geo'] else 'disabled'}}" href="riesgo/">Abrir</a>
            </div>
          </div>
        </div>           
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Georreferenciación de casos
              </div>
              <div class="description">
                <p>Módulo de georreferenciación de casos</p>
                <ul>
                  <li>Vista por comunas.</li>
                  <li>Agrupación por años.</li>
                  <li>Agrupación por semanas.</li>
                </ul>
                <br>
                <br>
              </div>
            </div>
            <div class="ui two bottom attached buttons">
              <a class="ui button {{'' if data['modules']['geo'] else 'disabled'}}" href="mapa/">Abrir</a>
            </div>
          </div>
        </div>
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Predicción de casos de la enfermedad
              </div>
              <div class="description">
                <p>Módulo de predicción estadística de casos usando datos de Google Trends</p>
                <ul>
                  <li>Predecir el número de casos.</li>
                </ul>
              </div>
            </div>
            <div class="ui three bottom attached buttons">
              <a class="ui button disabled" href="prediccion/">Abrir</a>
            </div>
          </div>
        </div> 
      </div>
    </div>
</body>

</html>