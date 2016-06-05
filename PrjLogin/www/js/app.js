/*
 * Please see the included README.md file for license terms and conditions.
 */


// This file is a suggested starting place for your code.
// It is completely optional and not required.
// Note the reference that includes it in the index.html file.


/*jslint browser:true, devel:true, white:true, vars:true */
/*global $:false, intel:false app:false, dev:false, cordova:false */



// This file contains your event handlers, the center of your application.
// NOTE: see app.initEvents() in init-app.js for event handler initialization code.

// function myEventHandler() {
//     "use strict" ;
// // ...event handler code here...
// }

var dados;
var sessao_usuario_id = 3; //null quando entrar no app
var sessao_pessoa_id = 2; //decidir melhor forma de capturar esse id

function getFormData($form){
    var unindexed_array = $form.serializeArray();
    var indexed_array = {};

    $.map(unindexed_array, function(n, i){
        indexed_array[n['name']] = n['value'];
    });

    return indexed_array;
}

function botaoPostUsuario(){
    var $form = $("form[name='formPostUsuario']");
    dados = getFormData($form);

    $.ajax( {
        type: 'post',
        data: JSON.stringify(dados),
        dataType: 'json',
        url:'https://yesod-trabalho-felipsimoes.c9users.io/cadastro/usuario',
        success:function(data) {
            $("#mensagemPostUsuario").addClass("alert-success");
            $("#mensagemPostUsuario").text("Usuário cadastrado com sucesso!");
            $("#mensagemPostUsuario").css("display","block");
        },
        error:function(data) {
            $("#mensagemPostUsuario").addClass("alert-danger");
            $("#mensagemPostUsuario").text("Ocorreu um erro durante o cadastro!");
            $("#mensagemPostUsuario").css("display","block");
        }
    });
}
function botaoPostPessoa(){
    var $form = $("form[name='formPostPessoa']");
    dados = getFormData($form);
    dados["uid"] = sessao_usuario_id; //usuario felipe

    return $.ajax( {
        type: 'post',
        async: false,
        data: JSON.stringify(dados),
        dataType: 'json',
        url:'https://yesod-trabalho-felipsimoes.c9users.io/cadastro/pessoa',
        success:function(data){
            console.log(data);
        },
        error:function(data){
            console.log(data);
        }
    });
}
function botaoPostFicha(){
    var $form = $("form[name='formPostFicha']");
    dados = getFormData($form);
    //dados["uid"] = sessao_usuario_id; //usuario felipe
    dados.peso = parseFloat(dados.peso.replace(",","."));
    dados.altura = parseFloat(dados.altura.replace(",","."));
    
    dados["pid"] = sessao_pessoa_id;
    
    return $.ajax( {
        type: 'post',
        async: false,
        data: JSON.stringify(dados),
        dataType: 'json',
        url:'https://yesod-trabalho-felipsimoes.c9users.io/cadastro/ficha',
        success:function(data){
            console.log(data);
        },
        error:function(data){
            console.log(data);
        }
    });
}

function botaoPostMedicamento(){
    var $form = $("form[name='formPostMedicamento']");
    dados = getFormData($form);
        
    return $.ajax( {
        type: 'post',
        async: false,
        data: JSON.stringify(dados),
        dataType: 'json',
        url:'https://yesod-trabalho-felipsimoes.c9users.io/cadastro/medicamento',
        success:function(data){
            console.log(data);
        },
        error:function(data){
            console.log(data);
        }
    });
    
}

function tratarAlerta(alerta){
    alerta.removeClass("alert-info");
    alerta.removeClass("alert-success"); 
    alerta.removeClass("alert-danger"); 
    alerta.removeClass("alert-info"); 
    alerta.text("");
}

function validarFormPostUsuario(){
    var email = document.forms.formPostUsuario.email.value.trim();
    var senha = document.forms.formPostUsuario.senha.value.trim();
    var senhaNovamente = document.forms.formPostUsuario.senhaNovamente.value.trim();
    var alerta = $("#mensagemPostUsuario");
    
    if(email === null || email === ""){
        alerta.text("Preencha com o email.");
    }
    else if(senha === null || senha === ""){
        alerta.text("Preencha com uma senha.");
    }
    else if(senha != senhaNovamente){
        alerta.text("Senhas não são iguais.");
    }
    else {
        return true;
    }
    alerta.addClass("alert-info");
    alerta.css("display","block");
    return false;
}


