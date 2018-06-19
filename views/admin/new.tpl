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
          <a href="/" class="ui button">Atrás</a>
        </div>
      </div>
    </div>
  </div>
  <div class="ui main text container">
    <div class="ui middle aligned center aligned grid">
        <div class="column">
          <h2 class="ui header">
            <div class="content">
              Crear usuario
            </div>
          </h2>
          <form class="ui large form" method="post" action="/usuarios/crear">
            <div class="ui stacked segment">
              <div class="two fields">
                <div class="field">
                  <div class="ui left icon input">
                    <i class="user icon"></i>
                    <input type="text" name="user" placeholder="Identificador del usuario">
                  </div>
                </div>
                <div class="field">
                    <select name="role">
                      <option value="viewer">Investigador</option>
                      <option value="editor">Editor</option>
                      <option value="admin">Administrador</option>
                    </select>
                </div>
              </div>
              <div class="two fields">
                <div class="field">
                    <div class="ui left icon input">
                      <i class="key icon"></i>
                      <input type="password" name="pass1" placeholder="Contraseña">
                    </div>
                  </div>
                  <div class="field">
                    <div class="ui left icon input">
                      <i class="key icon"></i>
                      <input type="password" name="pass2" placeholder="Repite la contraseña">
                    </div>
                  </div>
              </div>
              <br>
              <input type="submit" class="ui green large submit button" value="Guardar">
            </div>
            {{!error_msg}}
          </form>
        </div>
      </div>
  </div>

</body>

</html>