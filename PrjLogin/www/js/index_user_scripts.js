/*jshint browser:true */
/*global $ */(function()
{
 "use strict";
 /*
   hook up event handlers 
 */
 function register_event_handlers()
 {
           
        /* button  Limpar */
    $(document).on("click", ".uib_w_19", function(evt)
    {
        $("#formPostUsuario input[name=email]").val(''); 
        $("#formPostUsuario input[name=senha]").val(''); 
        $("#formPostUsuario input[name=senhaNovamente]").val(''); 
        $("#mensagemPostUsuario").css("display","none");
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
         activate_page("#alterar_pessoa"); 
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
    
        /* button  #salvar_dados_ficha */
    $(document).on("click", "#salvar_dados_ficha", function(evt)
    {
        botaoPostFicha().done(function(data){
            if(data.resp === "Criado"){
               activate_page("#menu");
            }else{
              alert("Erro");
            } 
        });
        return false;
    });
    
        /* button  .uib_w_123 */
    $(document).on("click", ".uib_w_123", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
    
        /* button  .uib_w_107 */
    $(document).on("click", ".uib_w_107", function(evt)
    {
         /*global activate_page */
         activate_page("#alterar_medicamento"); 
         return false;
    });
    
        /* button  .uib_w_124 */
    $(document).on("click", ".uib_w_124", function(evt)
    {
         /*global activate_page */
         activate_page("#lista_medicamentos"); 
         return false;
    });
    
        /* button  .uib_w_18 */
    $(document).on("click", ".uib_w_18", function(evt)
    {
         /*global activate_page */
         activate_page("#mainpage"); 
         return false;
    });
    
    
        /* button  .uib_w_125 */
    $(document).on("click", ".uib_w_125", function(evt)
    {
         /*global activate_page */
         activate_page("#mostrar_medicamento"); 
         return false;
    });
    
        /* button  .uib_w_126 */
    $(document).on("click", ".uib_w_126", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
        /* button  .uib_w_127 */
    $(document).on("click", ".uib_w_127", function(evt)
    {
         /*global activate_page */
         activate_page("#mostrar_ficha"); 
         return false;
    });
    
        /* button  .uib_w_129 */
    $(document).on("click", ".uib_w_129", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
        /* button  .uib_w_130 */
    $(document).on("click", ".uib_w_130", function(evt)
    {
         /*global activate_page */
         activate_page("#menu"); 
         return false;
    });
    
    
        /* button  #menu_cadastrar_ficha */
    $(document).on("click", "#menu_cadastrar_ficha", function(evt)
    {
         /*global activate_page */
         activate_page("#mostrar_ficha"); 
         return false;
    });
    
    
        /* button  #menu_alterar_pessoa */
    $(document).on("click", "#menu_alterar_pessoa", function(evt)
    {
         botaoGetPessoa().done(function(data){
            activate_page("#mostrar_pessoa");
            data = data.data;
            $("#nomeP").text(data.nome);
            $("#cpfP").text(data.cpf);
            $("#sexoP").text(data.sexo);
            $("#teleP").text(data.telefone);
            $("#dtnascP").text(data.dtnascimento);
            $("#cepP").text(data.cep);
            $("#enderecoP").text(data.endereco);
            $("#cidadeP").text(data.cidade);
            $("#npaiP").text(data.nomepai);
            $("#nmaeP").text(data.nomemae);
             
        });
        
        return false;
    });
    
        /* button  #menu_alterar_ficha */
    $(document).on("click", "#menu_alterar_ficha", function(evt)
    {
        botaoGetFicha().done(function(data){
            console.log(JSON.stringify(data.data));
            activate_page("#mostrar_ficha");
            $("#alergiaF").text(data.data.alergia);
            $("#doadorF").text(data.data.doador);
            $("#pesoF").text(data.data.peso);
            $("#alturaF").text(data.data.altura);
        });
        
        return false;
    });
    
          
        /* button  .uib_w_122 */
    $(document).on("click", ".uib_w_122", function(evt)
    {
        botaoGetMedicamento().done(function(data){
            activate_page("#mostrar_medicamento");
            $("#nomeM").text(data.nome);
            $("#dosageM").text(data.dosagem);
        }); 
        
         return false;
    });
    
        /* button  #menu_alterar_medicamento */
    $(document).on("click", "#menu_alterar_medicamento", function(evt)
    {
        botaoGetListaMedicamento().done(function(data){
            activate_page("#lista_medicamentos");
            $("#nomeLM").text(data.nome);
            $("#dosageLM").text(data.dosagem);
        });  
         return false;
    });
        
    
        /* button  #btn-cadastrar */
    $(document).on("click", "#btn-cadastrar", function(evt)
    {
        if(validarFormPostUsuario()==true){
            var idUsuario, idPessoa;
            botaoPostUsuario().done(function(data){
                if(data.status == "sucesso"){
                    idUsuario = data.idUsuario;
                    $("#mensagemPostUsuario").addClass("alert-success");
                    $("#mensagemPostUsuario").text("Usuário cadastrado com sucesso!");
                    $("#mensagemPostUsuario").css("display","block");
                    if(idUsuario != null){
                        botaoPostPessoa(idUsuario).done(function(data){
                            if(data.status == "sucesso"){
                                idPessoa = data.idPessoa;
                                if(idPessoa != null){
                                    botaoPostFicha(idPessoa).done(function(data){
                                       if(data.status == "sucesso"){
                                           console.log("ficha inserida com sucesso");
                                       }else{
                                           console.log("erro ao inserir ficha");
                                       }
                                    });
                               }
                            }else{
                                console.log("erro ao inserir pessoa");
                            }
                        });   
                    }
                }else{
                    $("#mensagemPostUsuario").addClass("alert-danger");
                    $("#mensagemPostUsuario").text("Ocorreu um erro durante o cadastro!");
                    $("#mensagemPostUsuario").css("display","block");
                }
            });
                    
        }
        return false;
    });
    
    
        /* button  #botao-registrar */
    $(document).on("click", "#botao-registrar", function(evt)
    {
         /*global activate_page */
         activate_page("#cadastro_usuario"); 
         return false;
    });
    
        /* button  #btn-entrar */
    $(document).on("click", "#btn-entrar", function(evt)
    {
        botaoPostLoginUsuario().done(function(data){
            if(data.senha == data.senhaDigitada){
                activate_page("#menu");
                sessao_usuario_id = data.uid;
                botaoGetPessoa().done(function(data){
                    console.log(data.data);
                    sessao_pessoa_id = data.data.id;
                });
            }
            else{
                console.log("Deu ruim."); 
            }
         });
         return false;
    });
    
 

    
    }
 document.addEventListener("app.Ready", register_event_handlers, false);
})();
