# etsAppFlutter
# Control de Cambios eTRACKER#

### Procedimiento para iniciar los cambios de codigo locales
1. `git checkout master` #Ir a la rama principal local.
1. `git pull origin dev` #Bajar info del branch remoto dev y ponerlo en master local.
1. Si NO existen conflictos con el pull (merge failed) ir al punto 7.  Si hay conflictos ir al punto 4.
1. Resuelva los conflictos usando Visual Code. Visual Code se abrirá automaticamente y resaltará los cambios detectados. Seleccionar la opción **Accept incomming change**. Guarde los cambios y cierre el o los archivo en Visual Code.
1. `git add .` # Para agregar a stage los cambios de los conflictos.
1. `git commit -m "[mensaje]"` # Para hacer commit de los cambios.
1. `git diff master origin/dev` #verificar si hay cambios NO deseados entre master local y dev remoto. 
1. Si hay diferencias presione la tecla **flecha abajo** para ver todas las diferencias, presione la tecla "**q**" para salir. Borre los archivos adicionales locales no necesarios en master local e ir al punto 2.
1. Si NO hay diferencias haga un branch local para el cambio de codigo. Ver punto 10. 
1. `git checkout -b [myBranchName]` #Ejemplos para nombres de branches feature, loginPageDev, etc.
1. Haga los cambios del codigo en la nueva rama [myBranchName].

### Procedimiento para subir los cambios de codigo al repo remoto
###### NOTA: SIEMPRE SUBIR AL BRANCH DEV REMOTO NUNCA AL MASTER REMOTO
1. `git checkout [myBranchName]` # Seleccionar el branch local creado para hacer el cambio.
1. `git pull origin dev` # Bajar el codigo del branch dev remoto y ponerlo en [myBranchName].
1. Si NO existen conflictos con el pull (merge failed) ir al punto 7.  Si hay conflictos ir al punto 4.
1. Resuelva los conflictos usando Visual Code. Visual Code se abrirá automaticamente y resaltará los cambios detectados. Seleccionar la mejor alternativa para los conflictos ya sea **Accept current change** (usar cambios locales) o bien **Accept both changes** (usar ambos cambios). Guarde los cambios y cierre el o los archivos en Visual Code.
1. `git add .` # Para agregar a stage los cambios de los conflictos.
1. `git commit -m "[mensaje]"` # Para hacer commit de los cambios.
1. `git diff [myBranchName] origin/dev`  # Verificar si hay cambios NO deseados o conflictos entre [myBranchName] y dev remoto. NOTA: presione la tecla **q** para salir de ver los cambios.
1. Si los cambios son los deseados ir al punto 12, si hay cambios NO deseados ir al punto 9.
1. Borre archivos adicionales locales no deseados o los cambios no deseados en [myBranchName] local.
1. `git add .` # Para agregar a stage los cambios de los archivos no deseados.
1. `git commit -m "[mensaje]"` y regrese al punto 7.  # Para hacer commit de los cambios no deseados
1. `git push origin [myBranchName]`.
1. Abra el repo remoto en una pagina web y hacer click en el boton verde **COMPARE & PULL REQUEST** para la rama [myBranchName].
1. Dé click en el boton gris **BASE** y seleccionar **DEV** para que la opcion quede asi: **base:dev**.
1. Asegurese que el boton gris **COMPARE** muestre **compare:[myBranchName]**.
1. Agregue comentarios sobre el pull request, ej, para que se va a meter el cambio.
1. De click en la liga **REVIEWERS** y agrege a su supervisor y **espere la aprobación** del cambio solicitado.
1. De click en la liga **LABELS** y asignele un tipo de cambio.
1. De click en el boton verde **CREATE PULL REQUEST**.
1. Notifique a su supervisor sobre el cambio y **espere a que el cambio sea aprobado por su supervisor**.
1. De click en el **TRIANGULO** que se encuentra a lado derecho del boton verde **MERGE PULL REQUEST**.
1. Seleccione la opcion **SQUASH AND MERGE**.
1. Asegurese de ver un circulo con una palomita y el siguiente texto **This branch has no conflicts with the base branch**.
1. Presione el boton verde **SQUASH AND MERGE**.
1. Presione el boton verde **CONFIRM SQUASH AND MERGE** para confirmar los cambios.
1. Borre la rama [myBranchName] presionando el boton gris **DELETE BRANCH**.
1. Asegurese de que sus cambios aparezcan en el branch **dev** remoto.
1. Regrese a su GIT local y seleccione el master branch con el comando `git checkout master`.
1. Borre la rama [myBranchName] con el commando  `git branch -d [myBranchName]`.
1. Felicidades usted ha completado este procedimiento.



### Comandos GIT potenciales a usar (en orden alfabetico):

- __git add .__
  - Agrega todos los cambios a stage.
- __git branch__
  - Ver branches de repo local. El * indica el Branch activo
- __git branch -d [branchName]__
  - Borrar una branch
- __git checkout [branchName or hashIdOfFile]__
  - Seleccionar una branch o un archivo anterior
- __git chechout -b [branchName]__
  - Crear una branch y seleccionar esa brach como el branch activo
- __git clone [repoAddress]__
  - Clonar un repo remoto
- __git commit -m "[message]"__
  - Guargar los cambios con control de version
- __git diff [branchName1 or fileName1]  [branchName2 or fileName2]__
  - Comparar branches o archivos
  - ej. __git diff master origin/master__
  - ej. __git diff myLocalBranch origin/dev__
- __git log__
  - Ver cambios del branch actual
- **git log __oneline**
  - Ver cambios del branch actual vista simplificada
- __git pull origin dev__
  - Baja los cambios del repo remoto y del branch remoto dev
- __git push origin [branchName]__
  - Sube los cambios del branch escrito al repo remoto  
- __git status__
  - Muestra el estatus de repo local  
