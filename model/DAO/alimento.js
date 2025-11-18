/*******************************************************************************************
 * objetivo: criar a comunicação com o banco de dados, para fazer o CROUD de alimentos
 * data: 17/10/25
 * autor: Eduarda Silva
 * versão: 1.0
 *******************************************************************************************/


// import da biblioteca do prisma client para executar os scripts SQL
const{PrismaClient} = require('@prisma/client')

// instancia (criar um objeto a ser utilizado) a bliblioteca do prisma/client
const prisma = new PrismaClient()

// função para inserir um novo filme
const insertAlimento = async function(alimento){
    try{
        
        let dataEntrada = alimento.data_de_validade
        if (dataEntrada.match(/^\d{2}\/\d{2}\/\d{4}$/)) {
            let [dia, mes, ano] = dataEntrada.split('/')
            dataEntrada = `${ano}-${mes}-${dia}`
        }else if (dataEntrada.match(/^\d{2}\/\d{2}\/\d{4}$/)) {
            let [dia, mes, ano] = dataEntrada.split('-')
            dataEntrada = `${ano}-${mes}-${dia}`
        }

        let result = await prisma.$executeRaw`CALL inserir_alimento(${alimento.nome}, ${alimento.quantidade}, ${alimento.peso}, ${alimento.dataEntrada}, ${alimento.descricao}, ${alimento.imagem}, ${alimento.id_empresa}, ${alimento.id_tipo_peso})`

       if (result === 1) { 
            let lastIdResult = await prisma.$queryRawUnsafe(`SELECT LAST_INSERT_ID() AS id`)

            let idGerado = lastIdResult[0].id

            return {
                id: Number(idGerado), 
                nome: alimento.nome,
                peso: alimento.peso,
                tipoPeso: alimento.id_tipo_peso,
                quantidade: alimento.quantidade,
                data_validade: alimento.data_de_validade,
                descricao: alimento.descricao,
                imagem: alimento.imagem,
                id_empresa:alimento.id_empresa
            }
        } else
          return false
 
    }catch (error){
       console.log(error);
        return false
    }
}


const selectAllAlimentos = async function(){
    try{

        //scriptSQL para retornar todos os dados
        let sql = 'select * from tbl_alimentos'

        //executa o scriptSQL no banco de dados e aguarda o retorno dos dados 
        let result = await prisma.$queryRawUnsafe(sql)

        if(result)
            return result
        else
            return false

    }catch(error){
        // console.log(error);
        return false
    }
}

const selecByIdAlimento = async function(id){
    
    try {
        let sql = `select * from tbl_alimentos where id = ${id}`

        let result =  await prisma.$queryRawUnsafe(sql)

        if (result) {
            return result
        } else {
            return false
        }
    } catch (error) {
        console.log(error);
        return false
    }

}

module.exports = {
    insertAlimento,
    selectAllAlimentos,
    selecByIdAlimento
}



