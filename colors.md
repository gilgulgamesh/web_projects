
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
    j = 2 .* sd
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
