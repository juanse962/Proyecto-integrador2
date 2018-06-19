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
    <div class="ui stackable two column vertically divided grid container">
      <div class="row">
        <div class="column">
          <div class="ui card">
            <div class="content">
              <div class="header">
                Usuarios
              </div>
              <div class="description">
                <p>Módulo de administración de usuarios</p>
                <ul>
                  <li>Agregar usuarios.</li>
                  <li>Actualizar contraseña.</li>
                  <li>Cambiar roles.</li>
                  <li>Eliminar usuarios.</li>
                </ul>
              </div>
            </div>
            <div class="ui three bottom attached buttons">
              <a class="ui button" href="usuarios/nuevo">Crear</a>
              <a class="ui button" href="usuarios/">Ver usuarios</a>
            </div>
          </div>
        </div>
    </div>
</body>

</html>