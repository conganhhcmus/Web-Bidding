

module.exports = {
    sortByIncreasingPrice: async array =>{
        let temp = array;

        for(let i = 0; i < array.length - 1; i ++){
            for(let j = i + 1; j < array.length; j++){
                if(temp[i].CURRENT_PRICE > temp[j].CURRENT_PRICE){
                    let t = temp[i];
                    temp[i] = temp[j];
                    temp[j] = t;
                }
            }
        }
        return temp;
    },

    sortByDecreasingEndTime: async array => {
        let temp = array;

        for(let i = 0; i < array.length - 1; i ++){
            for(let j = i + 1; j < array.length; j++){
                if(temp[i].END_TIME < temp[j].END_TIME){
                    let t = temp[i];
                    temp[i] = temp[j];
                    temp[j] = t;
                }
            }
        }
        return temp;
    }
}