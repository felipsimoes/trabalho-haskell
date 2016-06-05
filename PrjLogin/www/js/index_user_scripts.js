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
    
    
        /* button  Cadastrar */
    $(document).on("click", ".uib_w_16", function(evt)
    {   
        if(validarFormPostUsuario()==true){
            botaoPostUsuario();    
        }
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
    
        /* button  Entrar */
    $(document).on("click", ".uib_w_4", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
        /* button  Voltar */
    $(document).on("click", ".uib_w_60", function(evt)
    {
         /*global activate_page */
         activate_page("#mainpage"); 
         return false;
    });
    
        /* button  #enviar_medicamento */
    $(document).on("click", "#enviar_medicamento", function(evt)
    {
         var medData; 
         botaoPostMedicamento().done(function(data){
            if(data.resp === "Criado"){
               activate_page("#menu");
            }else{
              alert("Erro");
            } 
         });
         return false;
         
    });
    
        /* button  Esqueceu a senha? */
    $(document).on("click", ".uib_w_5", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_medicamento"); 
         return false;
    });
    
    }
 document.addEventListener("app.Ready", register_event_handlers, false);
})();
