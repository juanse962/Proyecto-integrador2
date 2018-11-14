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
  <script src="/js/app.js"></script>
  <script type="text/javascript">
    // preload background
    $('<img/>')[0].src = '/imgs/background.jpg';
  </script>
</head>
<body id="landing" onload="initHome()">

  <!-- Following Menu -->
  <div class="ui large top fixed hidden menu">
    <div class="ui container">
      <a class="active item" onclick='scroll2("top")'>Inicio</a>
      <a class="item" onclick='scroll2("modulos")'>Módulos</a>
      <a class="item" onclick='scroll2("equipo")'>Equipo</a>
      <a class="item" onclick='scroll2("patrocinadores")'>Patrocinadores</a>
      <div class="right menu">
        <div class="item">
          <a class="ui button" href="/ingreso/">Ingresar</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Sidebar Menu -->
  <div class="ui vertical inverted sidebar menu">
    <a class="active item" onclick='scroll2("top")'>Inicio</a>
    <a class="item" onclick='scroll2("modulos")'>Módulos</a>
    <a class="item" onclick='scroll2("equipo")'>Equipo</a>
    <a class="item" onclick='scroll2("patrocinadores")'>Patrocinadores</a>
    <a class="item" href="/ingreso/">Ingresar</a>
  </div>

  <!-- Page Contents -->
  <div id="top" class="pusher">
    <div id="top-layer" class="ui inverted vertical masthead center aligned segment">

      <div class="ui container">
        <div class="ui large secondary inverted pointing menu" style="border: none;">
          <a class="toc item">
            <i class="sidebar icon"></i>
          </a>
          <a class="active item" onclick='scroll2("top")'>Inicio</a>
          <a class="item" onclick='scroll2("modulos")'>Módulos</a>
          <a class="item" onclick='scroll2("equipo")'>Equipo</a>
          <a class="item" onclick='scroll2("patrocinadores")'>Patrocinadores</a>
          <div class="right item">
            <a class="ui inverted button" href="/ingreso/">Ingresar</a>
          </div>
        </div>
      </div>

      <div class="ui text container">
        <h1 class="ui inverted header">
          Epidemiología Matemática
        </h1>
        <h2>Plataforma web para el análisis, predicción y control de epidemias.</h2>
        <div class="ui huge primary button" onclick='scroll2("modulos")'>Ver más <i class="right arrow icon"></i></div>
      </div>

    </div>

  </div>
  <div id="modulos" class="ui vertical stripe segment">
    <div class="ui middle aligned stackable grid container">
      <div class="row">
        <div class="eight wide column">
          <h3 class="ui header">Descripción</h3>
          <p>Este software proporciona las herramientas necesarias para el análisis de las dinámicas relacionadas con el desarrollo de epidemias como el dengue.</p>
          <h3 class="ui header">Módulos</h3>
          <ul>
            <li><strong>Datos para procesamiento en cada módulo:</strong> Permite cargar archivos de Excel con los datos para los otros módulos.</li>
            <li><strong>Simulador para el control de la enfermedad:</strong> Realizar simulaciones con diferentes valores de fumigación en un modelo matemático.</li>
            <li><strong>Canal endémico:</strong> Permite utilizar 3 métodos para crear un canal endémico con base en la información de 3, 5 y 7 años anteriores.</li>
            <li><strong>Georrefenciación de casos:</strong> Muestra el mapa de la región segmentado para calcular los casos por clusters.</li>
            <li><strong>Predicción de casos de la enfermedad:</strong> Genera un predicción del número de casos a futuro con base en las búsquedas de Google.</li>
          </ul>
        </div>
        <div class="seven wide right floated column">
          <img src="/imgs/inicio.png" class="ui big bordered rounded image">
        </div>
      </div>
      <div class="row">
        <div class="center aligned column">
          <a class="ui huge button" onclick='scroll2("equipo")'>¿Quiénes somos?</a>
        </div>
      </div>
    </div>
  </div>
  <div id="equipo" class="ui vertical stripe segment">
    <div class="ui middle aligned stackable grid container">
      <h3 class="ui header">Docentes</h3>
      <div class="ui hidden divider"></div>
      <div class="row">
        <div class="column">
          <div class="ui link cards">

            <div class="card">
              <div class="image">
                <img src="/imgs/avatars/maria_eugenia.jpg">
              </div>
              <div class="content">
                <div class="header">María Eugenia Puerta Yepes</div>
                <div class="meta">
                  <a>Análisis Funcional, Optimización, Biomatemática.</a>
                </div>
                <div class="description">
                  Docente e investigadora de la Universidad EAFIT.
                </div>
              </div>
              <div class="extra content">
                <span class="right floated">
                  <a href="mailto:mpuerta@eafit.edu.co​">mpuerta@eafit.edu.co​</a>
                </span>
              </div>
            </div>

            <div class="card">
              <div class="image">
                <img src="/imgs/avatars/sair.jpg">
              </div>
              <div class="content">
                <div class="header">Sair Orieta Arboleda Sánchez</div>
                <div class="meta">
                  <a>Dengue, Epidemiología, Aedes aegypti.</a>
                </div>
                <div class="description">
                  Docente e investigadora.
                </div>
              </div>
              <div class="extra content">
                <span class="right floated">
                  <a href="mailto:sairorieta@gmail.com">sairorieta@gmail.com</a>
                </span>
              </div>
            </div>

            <div class="card">
              <div class="image">
                <img src="/imgs/avatars/carlos_mario.jpg">
              </div>
              <div class="content">
                <div class="header">Carlos Mario Vélez Sánchez</div>
                <div class="meta">
                  <a>​​Sistemas dinámicos, Teoría de la estimación, Sistemas de control.</a>
                </div>
                <div class="description">
                  Docente e investigador de la Universidad EAFIT.
                </div>
              </div>
              <div class="extra content">
                <span class="right floated">
                  <a href="mailto:cmvelez@eafit.edu.co​">cmvelez@eafit.edu.co​​</a>
                </span>
              </div>
            </div>

            <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/mauricio.jpg">
                </div>
                <div class="content">
                  <div class="header">Mauricio Toro Bermúdez</div>
                  <div class="meta">
                    <a>Simulación, Modelado, Ciencias de la computación.</a>
                  </div>
                  <div class="description">
                    Docente e investigador de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:mtorobe@eafit.edu.co​​">mtorobe@eafit.edu.co​​</a>
                  </span>
                </div>
              </div>
            <div class="card">
              <div class="image">
                <img src="/imgs/avatars/henry.jpg">
              </div>
              <div class="content">
                <div class="header">Henry Laniado Rodas</div>
                <div class="meta">
                  <a>​Estimación robusta de parámetros, Datos Funcionales, Teoría de riesgo.</a>
                </div>
                <div class="description">
                  Docente e investigador de la Universidad EAFIT.
                </div>
              </div>
              <div class="extra content">
                <span class="right floated">
                  <a href="mailto:hlaniado@eafit.edu.co​​">hlaniado@eafit.edu.co​​</a>
                </span>
              </div>
            </div>


          </div>
        </div>
      </div>
      <!-- <h4 class="ui horizontal divider header">
        <i class="users icon"></i>
        Estudiantes
      </h4> -->
      <h3 class="ui header">Estudiantes</h3>
      <div class="ui hidden divider"></div>
      <div class="row">
          <div class="column">
            <div class="ui link cards">
              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/paola.jpg">
                </div>
                <div class="content">
                  <div class="header">Paola Lizarralde Bejarano</div>
                  <div class="meta">
                    <a>Análisis Funcional, Epidemiología, Matemáticas Aplicadas.</a>
                  </div>
                  <div class="description">
                    Estudiante de Doctorado en Ingeniería Matemática de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:dlizarra@eafit.edu.co">dlizarra@eafit.edu.co​</a>
                  </span>
                </div>
              </div>
  
              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/alexa.jpg">
                </div>
                <div class="content">
                  <div class="header">Alexandra Cataño López</div>
                  <div class="meta">
                    <a>Estimación, Simulación, Epidemiología.</a>
                  </div>
                  <div class="description">
                    Estudiante de Maestría en Matemáticas Aplicadas de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:acatano@eafit.edu.co">acatano@eafit.edu.co</a>
                  </span>
                </div>
              </div>

              <div class="card">
                  <div class="image">
                    <img src="/imgs/avatars/catalina.jpg">
                  </div>
                  <div class="content">
                    <div class="header">Catalina Lesmes Ramírez</div>
                    <div class="meta">
                      <a>​​Modelación, Simulación, Estadística.</a>
                    </div>
                    <div class="description">
                      Estudiante de Ingeniería Matemática de la Universidad EAFIT.
                    </div>
                  </div>
                  <div class="extra content">
                    <span class="right floated">
                      <a href="mailto:clesmes@eafit.edu.co​">clesmes@eafit.edu.co​​</a>
                    </span>
                  </div>
                </div>

              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/camilo.jpg">
                </div>
                <div class="content">
                  <div class="header">Camilo Londoño López</div>
                  <div class="meta">
                    <a>​​Desarrollo Web, Análisis de sensibilidad, Análisis de incertidumbre.</a>
                  </div>
                  <div class="description">
                    Estudiante de Ingeniería Matemática de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:clondo30@eafit.edu.co​">clondo30@eafit.edu.co​​</a>
                  </span>
                </div>
              </div>
  
              <div class="card">
                  <div class="image">
                    <img src="/imgs/avatars/daniel.jpg">
                  </div>
                  <div class="content">
                    <div class="header">Daniel Rojas Díaz</div>
                    <div class="meta">
                      <a>​​Análisis de sensibilidad, Análisis de incertidumbre, Sistemas dinámicos.</a>
                    </div>
                    <div class="description">
                        Estudiante de Biología de la Universidad EAFIT.
                    </div>
                  </div>
                  <div class="extra content">
                    <span class="right floated">
                      <a href="mailto:drojasd@eafit.edu.co​​">drojasd@eafit.edu.co​​</a>
                    </span>
                  </div>
              </div>
              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/julian.jpg">
                </div>
                <div class="content">
                  <div class="header">Julián Herrera Gómez</div>
                  <div class="meta">
                    <a>Estimación de parámetros, Simulación, Supercomputación.</a>
                  </div>
                  <div class="description">
                      Estudiante de Ingeniería Matemática de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:jherre50@eafit.edu.co​​">jherre50@eafit.edu.co​​</a>
                  </span>
                </div>
              </div>
              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/henry2.jpg">
                </div>
                <div class="content">
                  <div class="header">Henry Giovanny Velasco Vera</div>
                  <div class="meta">
                    <a>Estimación, Datos Funcionales, Epidemiología.</a>
                  </div>
                  <div class="description">
                    Estudiante de Maestría en Matemáticas Aplicadas de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:hgvelascov@eafit.edu.co">hgvelascov@eafit.edu.co</a>
                  </span>
                </div>
              </div>
              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/andres.jpg">
                </div>
                <div class="content">
                  <div class="header">Andrés Pulgarín Rodriguez</div>
                  <div class="meta">
                    <a>Desarrollo Web, Predicción.</a>
                  </div>
                  <div class="description">
                      Estudiante de Ingeniería de Sistemas de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:apulgar3@eafit.edu.co​​">apulgar@eafit.edu.co​​</a>
                  </span>
                </div>
              </div>
              <div class="card">
                <div class="image">
                  <img src="/imgs/avatars/santiago.jpg">
                </div>
                <div class="content">
                  <div class="header">Santiago Escobar Mejia</div>
                  <div class="meta">
                    <a>Desarrollo Web.</a>
                  </div>
                  <div class="description">
                      Estudiante de Ingeniería de Sistemas de la Universidad EAFIT.
                  </div>
                </div>
                <div class="extra content">
                  <span class="right floated">
                    <a href="mailto:sescobarm3@eafit.edu.co​​">sescobarm@eafit.edu.co​​</a>
                  </span>
                </div>
              </div>
            </div>
          </div>
      </div>
    </div>
  </div>  
  <div id="patrocinadores" class="ui vertical stripe segment">
    <div class="ui equal width stackable grid">
      <div class="center aligned row">
        <div class="column">
          <h3>Financiado por</h3>
          <img src="/imgs/logos/colciencias.png">
        </div>
        <div class="column">
          <h3></h3>
          <img src="/imgs/logos/LogotipoEAFIT.png">
        </div>
        <div class="column">
          <h3></h3>
          <img src="/imgs/logos/Escudo-UdeA.png">
        </div>
      </div>
    </div>
  </div>

  <div class="ui inverted vertical footer segment">
    <div class="ui container">
      <div class="ui stackable inverted divided equal height stackable grid">
        <div class="three wide column">
          <h4 class="ui inverted header">Sobre este proyecto</h4>
          <div class="ui inverted link list">
            <a class="item" onclick='scroll2("top")'>Inicio</a>
            <a class="item" onclick='scroll2("modulos")'>Módulos</a>
            <a class="item" onclick='scroll2("equipo")'>Equipo</a>
            <a class="item" onclick='scroll2("patrocinadores")'>Patrocinadores</a>
          </div>
        </div>
        <div class="three wide column">
          <h4 class="ui inverted header">Módulos</h4>
          <div class="ui inverted link list">
            <a class="item" onclick='scroll2("modulos")'>Datos</a>
            <a class="item" onclick='scroll2("modulos")'>Simulador</a>
            <a class="item" onclick='scroll2("modulos")'>Predicción</a>
            <a class="item" onclick='scroll2("modulos")'>Canal endémico</a>
            <a class="item" onclick='scroll2("modulos")'>Georreferenciación</a>
          </div>
        </div>
        <div class="seven wide column">
          <h4 class="ui inverted header">Contacto</h4>
          <p>Ponte en contacto a tráves del siguiente correo</p>
          <a class="ui large button" href='mailto:epidemiologia.app@gmail.com'><i class="mail icon"></i>epidemiologia.app@gmail.com</a>
        </div>
      </div>
    </div>
  </div>

</body>

</html>
