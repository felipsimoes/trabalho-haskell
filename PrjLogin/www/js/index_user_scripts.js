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
    
    
        /* button  Esqueceu a senha? */
    $(document).on("click", ".uib_w_5", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
        /* button  #menu_mostrar_ficha_medica */
    $(document).on("click", "#menu_mostrar_ficha_medica", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_pessoa"); 
         return false;
    });
    
        /* button  #menu_cadastrar_medicamento */
    $(document).on("click", "#menu_cadastrar_medicamento", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_medicamento"); 
         return false;
    });
    
        /* button  #menu_cadastrar_pessoa */
    $(document).on("click", "#menu_cadastrar_pessoa", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_pessoa"); 
         return false;
    });
    
        /* button  #menu_cadastrar_ficha */
    $(document).on("click", "#menu_cadastrar_ficha", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_ficha"); 
         return false;
    });
    
        /* button  Voltar */
    $(document).on("click", ".uib_w_18", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
        /* button  #salvar_dados_pessoa */
    $(document).on("click", "#salvar_dados_pessoa", function(evt)
    {
        botaoPostPessoa().done(function(data){
            if(data.resp === "Criado"){
               activate_page("#menu");
            }else{
              alert("Erro");
            } 
         });
         return false;
    });
    
    }
 document.addEventListener("app.Ready", register_event_handlers, false);
})();
