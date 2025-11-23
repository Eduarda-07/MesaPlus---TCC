/*******************************************************************************************************
 * Objetivo:  criar a comunicação com o banco de dados, para fazer o CROUD de alimentoCategoria
 * Data: 30/10/2025
 * Autor: Eduara
 * Versão: 1.0
 ******************************************************************************************************/
//import da biblioteca do prisma client para executar os scripts SQL
const { PrismaClient } = require('@prisma/client')

//Instancia (criar um objeto a ser utilizado) a biblioteca do prisma/client
const prisma = new PrismaClient()


const insertAlimentoCat = async function(alimentoCat){
  try {

      let sql = `insert into tbl_alimento_categoria  ( 
                                          id_alimento,
                                          id_categoria
                                        ) 
                                          values 
                                        (
                                          ${alimentoCat.id_alimento},
                                          ${alimentoCat.id_categoria}
                                        )`
                                
      let result = await prisma.$executeRawUnsafe(sql)

       if (result === 1) { 
            let lastIdResult = await prisma.$queryRawUnsafe(`SELECT LAST_INSERT_ID() AS id`)

            let idGerado = lastIdResult[0].id

            return {
                id: Number(idGerado), 
                alimento: alimentoCat.id_alimento,
                categoria: alimentoCat.id_categoria
            }
        } else
          return false
  } catch (error) {
      
      return false
  }
}

const atualizarAlimentoCat = async function(alimentoCat){
  try {
                                
      let result = await prisma.$executeRaw`CALL atualizar_alimento_categoria(${alimentoCat.id_alimento}, ${alimentoCat.id_categoria})`

      if(result){
            return {
                alimento: alimentoCat.id_alimento,
                categoria: alimentoCat.id_categoria
            }
        } else
          return false
  } catch (error) {
      
      return false
  }
}


const selectCatByIdAlimento = async function(idAlimento){
 try {
      let sql = `SELECT tbl_categoria.* FROM tbl_alimento_categoria 
                   INNER JOIN tbl_categoria
                     ON tbl_categoria.id = tbl_alimento_categoria.id_categoria
                   WHERE tbl_alimento_categoria.id_alimento = ${idAlimento}`

      let result = await prisma.$queryRawUnsafe(sql)
      console.log(result);

    if (result && result.length > 0)
      
        return result
    else 
        return false
  } catch (error) {
      return false
  }
}



module.exports = {
    insertAlimentoCat,
    selectCatByIdAlimento, 
    atualizarAlimentoCat
} 