
ir() = trunc(Int, 12rand())

for k in 1:100
    seed = (ir(), ir(), ir())
    i = (230, 230, 230) .+ seed
    j = 3 .* seed
    for l in 1:10
        println(Crayon(foreground = j, background = i), "Bluish on yellow")
    end
end


#take each letter,
# convert to int,
Int(l)%26
# square,
# nahhh
# mod 25,
# use as ir
```jl
Int(l)%26

function s(str)
    a, b, c = str[end-2:end]
    (Int(a)%26, Int(b)%26, Int(c)%26)
end
function nameprint(name)
    sd = seedd(name)
    i = (190, 190, 190) .+ sd
    j = 3 .* sd
    for l in 1:10
        println(Crayon(foreground = j, background = i), "Bluish on yellow")
    end
end
```

```js


function seed(name) {
    var l = name.length;
    var a = name[l-3];
    var b = name[l-2];
    var c = name[l-1];

    var s1 = (a.charCodeAt(0)%26) ;
    var s2 = (b.charCodeAt(0)%26) ;
    var s3 = (c.charCodeAt(0)%26) ;
    //bold shold be the color * 10

    var bg = 'rgb(' + String(190+s1) + ', ' + String(190+s2) + ', ' + String(190+s3) + ')';
    var fg = 'rgb(' + String(3*s1) + ', ' + String(3*s2) + ', ' + String(3*s3) + ')';
    var vivid = 'rgb(' + String(10*s1) + ', ' + String(10*s2) + ', ' + String(10*s3) + ')';

    e = document.querySelector('article');
    e.style.backgroundColor = bg;
    e.style.color = fg;
    e.querySelector('h2').style.color = vivid;;
    e.querySelector('h4').style.color = vivid;;
    e.querySelector('b').style.color = vivid;;
    e.querySelector('a').style.color = vivid;;

    console.log(e.style);
};


```
i'm sdn in the simplest algo here with 190+letter mod 26

maybe use
```css
body {
    background-color: rgb(175, 175, 175);
}
```
