/******************************************************************************************************
 * objetivo: controller responsável pela regra de negócio referente ao CROUD de alimentos
 * data: 16/10/25
 * autor: Eduarda Silva
 * versão: 1.0
 ******************************************************************************************************/

const message = require('../../modulo/config')

const alimentoDAO = require('../../model/DAO/alimento')
const alimentoCatDAO = require('../../model/DAO/alimento_categoria')
const tipoDAO = require ('../../model/DAO/tipoPeso')
const empresaDAO = require('../../model/DAO/empresa')

const controllerAlimentoCat  = require('./controllerAlimentoCat')
const controllerTipoPeso  = require('../tipo de peso/controllerTipoPeso')
const controllerEmpresa = require('../empresas/controllerEmpresa')

const inserirAlimento = async function (alimento, contentType){
    try {
        if (String(contentType).toLocaleLowerCase() == 'application/json') {
            if (
                alimento.nome             == "" || alimento.nome             == undefined || alimento.nome             == null || alimento.nome.length       > 150 ||
                alimento.quantidade       == "" || alimento.quantidade       == undefined || alimento.quantidade       == null || isNaN(alimento.quantidade) || Number(alimento.quantidade) <= 0 ||
                alimento.peso             == "" || alimento.peso             == undefined || alimento.peso             == null || isNaN(alimento.peso) || Number(alimento.peso) <= 0 ||
                alimento.id_tipo_peso     == "" || alimento.id_tipo_peso     == undefined || alimento.id_tipo_peso     == null || isNaN(alimento.id_tipo_peso) || Number(alimento.id_tipo_peso) <= 0 ||
                alimento.data_de_validade == "" || alimento.data_de_validade == undefined || alimento.data_de_validade == null ||
                alimento.descricao        == "" || alimento.descricao        == undefined || alimento.descricao        == null ||
                alimento.imagem           == "" || alimento.imagem           == undefined || alimento.imagem           == null ||
                alimento.id_empresa       == "" || alimento.id_empresa       == undefined || alimento.id_empresa        == null || isNaN(alimento.id_empresa) || Number(alimento.id_empresa) <= 0 
            ) {
               
                return message.ERROR_REQUIRED_FIELD

            } else {
                    
                let idTipoPeso = Number(alimento.id_tipo_peso)
                
                let tipoExiste = await tipoDAO.selectTipoPesoById(idTipoPeso)

                if (tipoExiste === false) {
                    return message.ERROR_INTERNAL_SERVER_MODEL
                }

                if (tipoExiste === null) {
                     
                    return message.ERROR_NOT_FOUND
                
                }

                let idEmpresa = Number(alimento.id_empresa)
                
                let empresaExiste = await empresaDAO.selectEmpresaById(idEmpresa)

                if (empresaExiste === false) {
                    return message.ERROR_INTERNAL_SERVER_MODEL
                }

                if (empresaExiste === null) {
                     
                    return message.ERROR_NOT_FOUND
                
                }


                let resultAlimento = await alimentoDAO.insertAlimento(alimento)

                if (resultAlimento) {
                    let resultados = []
                    if (alimento.categorias && Array.isArray(alimento.categorias)) {

                        for(let categoria  of alimento.categorias){

                            if (categoria.id && !isNaN(categoria.id)) {
                                let alimentoCat = {
                                    id_alimento: resultAlimento.id,
                                    id_categoria : categoria.id
                                }
                               let resultAlimentoCat =  await alimentoCatDAO.insertAlimentoCat(alimentoCat)
                                console.log(`resultado do insert alimentoCat ${resultAlimentoCat}` );
                                
                               resultados.push(resultAlimentoCat.categoria)
                            } 
                        }
                    } 

                    let dados = {
                        status: true,
                        status_code: message.SUCCESS_CREATED_ITEM.status_code,
                        message: message.SUCCESS_CREATED_ITEM.message,
                        alimento: resultAlimento,
                        categorias: resultados
                    }                    
                    return dados
                } else {
                    return message.ERROR_INTERNAL_SERVER_MODEL
                }
            }
        } else {
            return message.ERROR_CONTENT_TYPE
        }
    } catch (error) {

        console.log(error);

        return message.ERROR_INTERNAL_SERVER_CONTROLLER

    }
}


const atualizarAlimento = async function (id, alimento, contentType){
    try {
        if (String(contentType).toLocaleLowerCase() == 'application/json') {
            if    (
                id    == ""  || id    == undefined  || id   == null  || isNaN(id)  || id <= 0 
            ){
               
                return message.ERROR_REQUIRED_FIELD

            } else {
               
                let camposPrincipais = [
                    alimento.nome, 
                    alimento.quantidade, 
                    alimento.peso, 
                    alimento.data_de_validade, 
                    alimento.descricao, 
                    alimento.imagem
                ]

       
                let campoPrincipalValido = camposPrincipais.some(campo => 
                    campo !== "" && campo !== undefined && campo !== null
                )
        
        
                let categoriaValida = false
                if (alimento.categorias && Array.isArray(alimento.categorias)) {
                    categoriaValida = alimento.categorias.some(cat => 
                        !isNaN(cat) && Number(cat) > 0
                    )
                 }
        
                // Se NENHUM campo principal foi fornecido E NENHUMA categoria válida foi fornecida, retorna erro.
                if (!campoPrincipalValido && !categoriaValida) {
                    return message.ERROR_REQUIRED_FIELD;
                }
                if(id){
                    let idAlimento = Number(id)
                    
                    let alimentoExiste = await alimentoDAO.selecByIdAlimento(idAlimento)

                    if (alimentoExiste === false) {
                        return message.ERROR_INTERNAL_SERVER_MODEL
                    }

                    if (alimentoExiste === null) {
                        return message.ERROR_NOT_FOUND
                    }
                }
                
                    let resultAlimento = await alimentoDAO.atualizarAlimento(id, alimento)

                    if (resultAlimento) {
                        let resultados = []
                        if (categoriaValida) {

                            for(let categoria of alimento.categorias){
                               if (!isNaN(categoria) && Number(categoria) > 0) { 

                                let alimentoCat = {
                                    id_alimento : Number(id), 
                                    id_categoria : Number(categoria) 
                                }

                                let resultAlimentoCat = await alimentoCatDAO.atualizarAlimentoCat(alimentoCat)
                                
                                if (resultAlimentoCat) {
                                    resultados.push(resultAlimentoCat)
                                }
                            } 
                        }
                    } 

                    let dados = {
                        status: true,
                        status_code: message.SUCCESS_UPDATED_ITEM.status_code,
                        message: message.SUCCESS_UPDATED_ITEM.message,
                        alimento: resultAlimento,
                        categorias: resultados
                    }
                    
                    return dados
                } else {
                    return message.ERROR_INTERNAL_SERVER_MODEL
                }
                
            }
        } else {
            return message.ERROR_CONTENT_TYPE
        }
    } catch (error) {

        console.log(error);

        return message.ERROR_INTERNAL_SERVER_CONTROLLER

    }
}


const listarAlimento = async function(){
    try {

        let arrayAlimentos = []
        
        let dadosAlimento = {}

        let resultAlimento = await alimentoDAO.selectAllAlimentos()

        if(resultAlimento != false || typeof(resultAlimento) == 'object'){
            if(resultAlimento.length > 0){

                //criando um JSON de retorno de dados para API
                dadosAlimento.status = true
                dadosAlimento.status_code = 200
                dadosAlimento.items = resultAlimento.length

                //Precisamos utilizar o for of, pois o foreach não consegue trabalhar com requisições async com await
                for(const itemAlimento of resultAlimento){
            
                    const idEmpresa = parseInt(itemAlimento.id_empresa)
                    
                    let dadosEmpresa = await controllerEmpresa.buscarEmpresa(idEmpresa)

                    if (dadosEmpresa && dadosEmpresa.empresa) {
                        itemAlimento.empresa = dadosEmpresa.empresa
                         //Remover o id do JSON
                        delete itemAlimento.id_empresa 
                    } else {
                        delete itemAlimento.id_empresa
                        itemAlimento.empresa = null 
                    }

                    const idTipoPeso = parseInt(itemAlimento.id_tipo_peso)
                    
                    let dadosTipo = await controllerTipoPeso.buscarTipoPeso(idTipoPeso)

                    if (dadosTipo && dadosTipo.tipo) {
                        itemAlimento.tipoPeso = dadosTipo.tipo
                         //Remover o id do JSON
                        delete itemAlimento.id_tipo_peso  
                    } else {
                
                        delete itemAlimento.id_tipo_peso  
                        itemAlimento.tipoPeso = null 
                    }

                    let dadosCategoria = await controllerAlimentoCat.buscarCatPorAlimento(itemAlimento.id)
                
                    // verificando se retorna array e se não é false
                   if (dadosCategoria && dadosCategoria.status_code == 200 && Array.isArray(dadosCategoria.categoria)){
                        itemAlimento.categorias = dadosCategoria.categoria
                    } else {
                        itemAlimento.categorias = []
                    }

                    arrayAlimentos.push(itemAlimento)
 
                }
                dadosAlimento.alimentos = arrayAlimentos.sort((a, b) => b.id - a.id)

                return dadosAlimento

            }else{
                return message.ERROR_NOT_FOUND //404
            }
        }else{
            return message.ERROR_INTERNAL_SERVER_MODEL //500
        }
    } catch (error) {
        console.log(error);
        
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

const buscarAlimento = async function(id){
    
    try {

        if ( id === ""   ||   id === undefined || id === null  || isNaN(id)  || id <= 0 ) {
            
            return message.ERROR_REQUIRED_FIELD //400

        } else {

            let arrayAlimento = []
            let dadosAlimento = {}

            let result = await alimentoDAO.selecByIdAlimento(parseInt(id))

            if(result != false || typeof(result) == 'object'){

                if(result.length > 0){

                    dadosAlimento.status = true
                    dadosAlimento.status_code = 200
                    
                    for(const item of result){
                        
                        const idEmpresa = parseInt(item.id_empresa)
                    
                        let dadosEmpresa = await controllerEmpresa.buscarEmpresa(idEmpresa)

                        if (dadosEmpresa && dadosEmpresa.empresa) {
                            item.empresa = dadosEmpresa.empresa
                            //Remover o id do JSON
                            delete item.id_empresa  
                        } else {
                            // console.log(dadosEmpresa)
                            delete item.id_empresa  
                            item.empresa = null 
                        }
                        
                        const idTipoPeso = parseInt(item.id_tipo_peso)
                    
                        let dadosTipo = await controllerTipoPeso.buscarTipoPeso(idTipoPeso)
    
                        if (dadosTipo && dadosTipo.tipo) {
                            item.tipoPeso = dadosTipo.tipo
                             //Remover o id do JSON
                            delete item.id_tipo_peso  
                        } else {
                    
                            delete item.id_tipo_peso  
                            item.tipoPeso = null 
                        }

                        let dadosCategoria = await controllerAlimentoCat.buscarCatPorAlimento(item.id)
                    

                        // verificando se retorna array e se não é false
                       if (dadosCategoria && dadosCategoria.status_code == 200 && Array.isArray(dadosCategoria.alimentoCat)){
                            item.categorias = dadosCategoria.alimentoCat
                        } else {
                            item.categorias = []
                        }
                        arrayAlimento.push(item)
     
                    }
                    dadosAlimento.alimento = arrayAlimento
    
                    return dadosAlimento
                }else{
                    return message.ERROR_NOT_FOUND //404
                }
          
            }else {
                return message.ERROR_INTERNAL_SERVER_MODEL //500
            }
        }
    } catch (error) {
        console.log(error)
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}


const excluirAlimento = async function(id){
    try {
        if (id == '' || id == undefined || id == null || isNaN(id) || id <= 0) {
            return message.ERROR_REQUIRED_FIELD 
        } else {

            let result = await alimentoDAO.selecByIdAlimento(parseInt(id))

            if(result != false || typeof(result) == 'object'){

                if (result.length > 0) {
    
                    let result = await alimentoDAO.deletAlimento(parseInt(id))

                    if (result) {
                        return message.SUCCESS_DELETED_ITEM //200
                    } else {
                        return message.ERROR_INTERNAL_SERVER_MODEL //500
                    }
    
                } else {
                    return message.ERROR_NOT_FOUND //404
                }
            }else{
                return message.ERROR_INTERNAL_SERVER_MODEL //500
            }
        }
    } catch (error) {
        return message.ERROR_INTERNAL_SERVER_CONTROLLER //500
    }
}

module.exports = {
    inserirAlimento,
    listarAlimento, 
    buscarAlimento,
    excluirAlimento,
    atualizarAlimento
}

