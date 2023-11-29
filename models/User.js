const {mapUsers} = require('../utils/mapUsers');

class User {
    static _client;
    static _tableName;

    static async findAll() {
        return await this._client.query(`SELECT * FROM ${this._tableName}`)
    }

    static async bulcCreate(usersArray) {
       return await this._client.query(`INSERT INTO ${this._tableName} (first_name, last_name, email, birthday, gender, is_subscribe) VALUES ${mapUsers(usersArray)};`);
    }
}

module.exports = User;