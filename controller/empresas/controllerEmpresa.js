/****************************************************************************************************
 * Objetivo: controller responsável pela regra de negócio referente ao CROUD de empresas
 * Data: 18/09/25
 * Autor: Eduarda Silva
 * Versão: 1.0
 ***************************************************************************************************/

// import do arquivo de mensagens e status code o projeto
const message = require('../../modulo/config.js')

const empresaDAO = require('../../model/DAO/empresa.js')

//import da biblioteca para criptografar as senhas
const bcrypt = require('bcrypt')

// função para tratar a inserção de uma nova empresa
const inserirEmpresa = async function (empresa, contentType) {

    try {
        
        // usar contentType para especificar quem chega no corpo da requisição, especificando que deve ser JSON
        if (String(contentType).toLowerCase() == 'application/json'){
            if
            (
                empresa.nome      == ""  || empresa.nome     == undefined  || empresa.nome     == null  || empresa.nome.length     > 100  ||
                empresa.email     == ""  || empresa.email    == undefined  || empresa.email    == null  || empresa.email.length    > 100  ||
                empresa.senha     == ""  || empresa.senha    == undefined  || empresa.senha    == null  ||   
                empresa.cnpj_mei  == ""  || empresa.cnpj_mei == undefined  || empresa.cnpj_mei == null  || empresa.cnpj_mei.length > 15   ||
                empresa.telefone  == ""  || empresa.telefone == undefined  || empresa.telefone == null  || empresa.telefone.length > 15   ||
                empresa.endereco  == ""  || empresa.endereco == undefined  || empresa.endereco == null  || empresa.endereco.length > 150   
            ){
                return message.ERROR_REQUIRED_FIELD //400
            } else {
                // criptografando a senha
                let hashedSenha
                try {
                    // o numero 10 é um nível de segurança basico
                    hashedSenha = await bcrypt.hash(empresa.senha, 10)
                } catch (hashError) {
                    console.log("Erro ao gerar hash da senha:", hashError)
                    return message.ERROR_INTERNAL_SERVER_CONTROLLER // erro no servidor da controller
                }
                
                empresa.senha = hashedSenha

                let resultInsert = await empresaDAO.insertEmpresa(empresa)
     
                if (resultInsert === 'ERROR_DUPLICATE_ENTRY') {
                     return message.ERROR_DUPLICATE
                }
     
                if (resultInsert){
                    let dadosEmpresa = {
                        status: true,
                        status_code: message.SUCCESS_CREATED_ITEM.status_code,
                        message: message.SUCCESS_CREATED_ITEM.message,
                        empresa: resultInsert
                    }
                    return dadosEmpresa
                } else {
                    return message.ERROR_INTERNAL_SERVER_MODEL // Retorna 500 - Erro no modelo/DAO
                }
            }
        } else {
            return message.ERROR_CONTENT_TYPE //415
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

const listarEmpresas = async function(){
    try {

        let dadosEmpresa = {}

        let result = await empresaDAO.selectAllEmpresas()

        if(result != false || typeof(result) == 'object'){
            if(result.length > 0){
                dadosEmpresa.status = true
                dadosEmpresa.status_code = 200
                dadosEmpresa.itens = result.length
                dadosEmpresa.empresas = result
        
                return dadosEmpresa

            }else{
                return message.ERROR_NOT_FOUND //404
            }
        }else{
            return message.ERROR_INTERNAL_SERVER_MODEL //500
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

const buscarEmpresa = async function(id){
    try {
        if ( id === ""   ||   id === undefined || id === null  || isNaN(id)  || id <= 0 ) {
            
            return message.ERROR_REQUIRED_FIELD //400

        } else {
            let dadosEmpresa = {}

            let result = await empresaDAO.selectEmpresaById(parseInt(id))

            if(result && typeof(result) === 'object'){
                
                dadosEmpresa.status = true
                dadosEmpresa.status_code = 200
                dadosEmpresa.empresa = result 
 
                return dadosEmpresa
            }else{
                // Se o resultado for null (404) ou false (500)
                if (result === null) {
                    return message.ERROR_NOT_FOUND //404
                } else {
                    return message.ERROR_INTERNAL_SERVER_MODEL //500 (Erro no DAO)
                }
            }
        }
    } catch (error) {
        // console.log(error)
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

const atualizarEmpresa = async function (id, empresa, contentType) {
    try {
        // usar contentType para especificar quem chega no corpo da requisição, especificando que deve ser JSON        
        if (String(contentType).toLowerCase() == 'application/json'){
            if
            (
                id            == ""  || id           == undefined  || id           == null  || isNaN(id)  || id <= 0 ||
                (
                    (empresa.nome      == ""  || empresa.nome     == undefined  || empresa.nome     == null  || empresa.nome.length     > 100 )  && 
                    (empresa.email     == ""  || empresa.email    == undefined  || empresa.email    == null  || empresa.email.length    > 100  ) &&
                    (empresa.senha     == ""  || empresa.senha    == undefined  || empresa.senha    == null ) &&
                    (empresa.telefone  == ""  || empresa.telefone == undefined  || empresa.telefone == null  || empresa.telefone.length > 15) &&
                    (empresa.endereco  == ""  || empresa.endereco == undefined  || empresa.endereco == null  || empresa.endereco.length > 150)
                )
            ){
                return message.ERROR_REQUIRED_FIELD //400
            } else {

                let resultEmpresa = await empresaDAO.selectEmpresaById(parseInt(id))

                if (resultEmpresa) {
                    let senhaNova = empresa.senha
        
                    if (empresa.senha) {
                        try {
                            senhaNova = await bcrypt.hash(empresa.senha, 10);
                        } catch (hashError) {
                            console.error("Erro ao gerar hash da senha:", hashError);
                            return message.ERROR_INTERNAL_SERVER_CONTROLLER // 500
                        }
                    }
            
                    let dadosParaUpdate = {
                        nome: empresa.nome || null,
                        email: empresa.email || null,
                        senha: senhaNova || null,
                        telefone: empresa.telefone || null,
                        foto: (empresa.foto !== undefined) ? empresa.foto : null,
                        endereco: empresa.endereco || null
                    }
    
                    let result = await empresaDAO.updateEmpresa(id, dadosParaUpdate)
    
                    if (result){
                        let dadosEmpresa = {
                            status: true,
                            status_code: message.SUCCESS_UPDATED_ITEM.status_code,
                            message: message.SUCCESS_UPDATED_ITEM.message,
                            empresa: empresa
                        }
                        return dadosEmpresa
                    } else {
                        
                        return message.ERROR_INTERNAL_SERVER_MODEL // Retorna 500 - Erro no modelo/DAO
                    }
                } else {
                    return message.ERROR_NOT_FOUND
                }
            }
        } else {
            return message.ERROR_CONTENT_TYPE //415
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

// exportando funções
module.exports = {
    inserirEmpresa,
    listarEmpresas,
    buscarEmpresa, 
    atualizarEmpresa
}