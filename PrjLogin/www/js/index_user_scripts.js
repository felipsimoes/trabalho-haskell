/*jshint browser:true */
/*global $ */(function()
{
 "use strict";
 /*
   hook up event handlers 
 */
 function register_event_handlers()
 {
    
    
     /* button  Entrar */
    
    
        /* button  Button */
    
    
        /* button  .uib_w_18 */
    $(document).on("click", ".uib_w_18", function(evt)
    {
         /*global activate_page */
         activate_page("#mainpage"); 
    });
    
        /* button  Entrar */
    
    
        /* button  Registrar */
    $(document).on("click", ".uib_w_14", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_usuario"); 
    });
    
        /* button  Entrar */
    $(document).on("click", ".uib_w_4", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_pessoa"); 
    });
    
        /* button  Cadastrar */
    $(document).on("click", ".uib_w_16", function(evt)
    {   
        validarFormPostUsuario();
        botaoPostUsuario();
        return false;
    });
    
        /* button  Limpar */
    $(document).on("click", ".uib_w_19", function(evt)
    {
        $("#formPostUsuario input[name=email]").val(''); 
        $("#formPostUsuario input[name=senha]").val(''); 
        $("#formPostUsuario input[name=senhaNovamente]").val(''); 
        $("#mensagemPostUsuario").css("display","none");
        return false;
    });
    
    }
 document.addEventListener("app.Ready", register_event_handlers, false);
})();
