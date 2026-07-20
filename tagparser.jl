using DelimitedFiles, Hyperscript

function seed(str)
    a, b, c = str[end-2:end]
    (Int(a), Int(b), Int(c) .- 97) .%26
end
function pallete(name)
    sd = seed(name)
    bg = (175, 175, 175) .+ sd
    text = 2 .* sd
    vivid = 7 .* sd
    link = (30,30,30) .+ vivid
    bg, text, vivid, link
end

const BG = 1
const TEXT = 2
const VIVID = 3
const LINK = 4


function gathercolors(users)

    colors = Dict()

    for u in users
        get!(colors, u, pallete(u) )
    end
    colors
end


function makecss(users)
    colors = gathercolors(users)
    c = []
    for user in keys(colors)
        push!(c,
            css(".$user",
                color = "rgb$(colors[user][TEXT])",
                backgroundColor = "rgb$(colors[user][BG])",
                # css("b",
                #      color = "rgb$(colors[user][VIVID])"),
                # css("strong",
                #      color = "rgb$(colors[user][VIVID])"),
                css("h2",
                     color = "rgb$(colors[user][VIVID])"),
                css("h4",
                     color = "rgb$(colors[user][VIVID])"),

                # css(".bottom",
                #      color = "rgb$(colors[user][VIVID])"), # make these real VIVIDs lol not the color
                css("a",
                     color = "rgb$(colors[user][VIVID])")
            )
        )

    end
    c
end
