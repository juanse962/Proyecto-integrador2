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
    div.right.floated.content form{
      display: inline-block;
    }
  </style>
  <script type="text/javascript">
  function confirmar(){
    return confirm('¿Desea borrar este usuario?')
  }
  </script>
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
    <div class="ui large aligned center divided list">
      <h2 class="ui header">
        <div class="content">
          Usuarios
        </div>
      </h2>
      % for user in data:
      <div class="item icon left">
        <div class="right floated content">
          <form action="/usuarios/eliminar" method="post" onsubmit=confirmar()>
            <input type="hidden" name="id" value="{{user['_id']}}">
            <input type="submit" name="submit" class="ui red button" value="Eliminar">
          </form>
          &nbsp;
          <form action="/usuarios/actualizar" method="post">
            <input type="hidden" name="user" value="{{user['user']}}">
            <input type="hidden" name="role" value="{{user['role']}}">            
            <input type="submit" name="submit" class="ui green button" value="Actualizar">
          </form>
        </div>
        <i class="user icon"></i>
        <div class="content">
          {{user['user']}} <div class="ui horizontal label">{{{'viewer':'Investigador','editor':'Editor','admin':'Admin'}[user['role']]}}</div>
        </div>
      </div>
      % end
    </div>
  </div>

</body>

</html>
