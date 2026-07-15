
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

    var s1 = ((a.charCodeAt(0)-97)%26) ;
    var s2 = ((b.charCodeAt(0)-97)%26) ;
    var s3 = ((c.charCodeAt(0)-97)%26) ;
    //bold shold be the color * 10

    var bg = 'rgb(' + String(195+s1*0.75) + ', ' + String(195+s2*0.75) + ', ' + String(195+s3*0.75) + ')';
    var fg = 'rgb(' + String(2.5*s1) + ', ' + String(2.5*s2) + ', ' + String(2.5*s3) + ')'; //3*?
    var vivid = 'rgb(' + String(7*s1) + ', ' + String(7*s2) + ', ' + String(7*s3) + ')';

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
  --light-green: hsl(1, 0%, 74%);
```

```jl
function seed(str)
    a, b, c = str[end-2:end] 
    s1, s2, s3 = Int(a), Int(b), Int(c)
    ((s1, s2, s3) .- 97) .%26
end
function s(name)
    sd = seed(name)
    i = (175, 175, 175) .+ sd
    j = 3 .* sd
    k = 7 .* sd
    l = (30,30,30) .+ k
    println(Crayon(foreground = k, background = i), "   $name")
    
    # for line in 1:10
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = l, background = i, underline=true), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        println(Crayon(foreground = j, background = i, underline=false), "   $(name^6)")
        
    # end
    for gap in 1:2
        println(Crayon( foreground =(180, 185, 185),  background =(185, 185, 185)), " ")
    end
end
rc() = Char(rand(UInt)%26 + 97)
r3c() = rc() * rc() * rc()


for boob in 1:10
    s(r3c())
end


```
