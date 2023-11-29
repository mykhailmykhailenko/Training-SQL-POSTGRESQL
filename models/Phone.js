class Phone {
    static _client;
    static _tableName;

    static async bulkCreate (phones) {
        const valueString = phones.map(({brand, model, price, quantity}) => `('${brand}', '${model}' , ${price}, ${quantity})`).join(',');

        const {rows} = await this._client.query(`INSERT INTO ${this._tableName} (brand, model, price, quantity) VALUES ${valueString} RETURNING *`);

        return rows;
    }

    static async findAll () {
        return await this._client.query(`SELECT * FROM ${this._tableName};`)
    }
}

module.exports = Phone;