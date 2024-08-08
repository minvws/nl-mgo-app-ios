var exposedFunc = function(input) {
    let inputValueDisplay = '';
    if (input !== undefined) {
        const inputValue = JSON.parse(input);
        inputValueDisplay = input;
    }
    return  JSON.stringify({
        label: 'ui schema main title',
        children: [
            {
                label: 'group label',
                children: [
                    {
                        label: 'test label',
                        display: 'Voluptate ex voluptatum alias excepturi saepe atque reprehenderit soluta id autem quasi suscipit minima.',
                    },
                    {
                        label: 'input',
                        display: inputValueDisplay,
                    }
                ]
            }
        ]
    });
}
//export function testJson(input) {
//    return JSON.stringify(test(input));
//}
