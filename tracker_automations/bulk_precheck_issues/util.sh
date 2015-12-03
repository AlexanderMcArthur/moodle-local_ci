#!/bin/bash
set -e

# Generates tracker code for positive emotion
function positive_tracker_emoticon() {
    local rand=$[ RANDOM % 5]
    # Only do fun stuff 1/6 of the time:
    if [[ $rand -eq 0 ]]
    then
        image=$(get_happy_image)
        echo "!${image}!"
    else
        echo  '(y)'
    fi
}

# Generates tracker comment code for negative emotion
function negative_tracker_emoticon() {
    local rand=$[ RANDOM % 5]
    # Only do fun stuff 1/6 of the time:
    if [[ $rand -eq 0 ]]
    then
        image=$(get_sad_image)
        echo "!${image}!"
    else
        echo  '(n)'
    fi
}


function get_happy_image() {
    # balloon🎈
    images[0]='//twemoji.maxcdn.com/16x16/1f388.png'
    # party popper 🎉
    images[1]='//twemoji.maxcdn.com/16x16/1f389.png'
    # clinking beer mugs 🍻
    images[2]='//twemoji.maxcdn.com/16x16/1f37b.png'
    # cookie 🍪
    images[3]='//twemoji.maxcdn.com/16x16/1f36a.png'
    # cake 🍰
    images[4]='//twemoji.maxcdn.com/16x16/1f370.png'
    # glowing star 🌟
    images[5]='//twemoji.maxcdn.com/16x16/1f31f.png'
    # smiling face with halo 😇
    images[6]='//twemoji.maxcdn.com/16x16/1f607.png'

    index=$[$RANDOM % ${#images[@]}]
    echo ${images[$index]}
}

function get_sad_image() {
    # fire 🔥
    images[0]='//twemoji.maxcdn.com/16x16/1f525.png'
    # pile of poo 💩
    images[1]='//twemoji.maxcdn.com/16x16/1f4a9.png'
    # speak-no-evil monkey 🙊
    images[2]='//twemoji.maxcdn.com/16x16/1f64a.png'
    # bug 🐜
    images[3]='//twemoji.maxcdn.com/16x16/1f41c.png'
    # face screaming in fear 😱
    images[4]='//twemoji.maxcdn.com/16x16/1f631.png'
    # construction sign 🚧
    images[5]='//twemoji.maxcdn.com/16x16/1f6a7.png'
    # sos 🆘
    images[6]='//twemoji.maxcdn.com/16x16/1f198.png'
    # skull 💀
    images[7]='//twemoji.maxcdn.com/16x16/1f480.png'

    index=$[$RANDOM % ${#images[@]}]
    echo ${images[$index]}
}
