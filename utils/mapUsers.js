module.exports.mapUsers = (usersArray) => {
    return usersArray.map(({name: {first, last}, email, dob: {date}, gender}) => `('${first}', '${last}', '${email}', '${date}', '${gender}', '${Boolean(Math.random() > 0.5)}')`).join(',');
}