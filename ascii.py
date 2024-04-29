from PIL import Image
def asciiConvert(image, type, saveas, scale):
    scale = int(scale)

    img = Image.open(image)
    w,h = img.size

    img.resize((w//scale,h//scale)).save("resized1.%s" % type)
    img = Image.open("resized1.%s" % type)
    w,h = img.size # get the new width and height
    
    grid = []
    
    for i in range(h):
        grid.append(["X"]*w)
    
    """Allocates storage for the image and loads the pixel data"""
    pix = img.load()

    for y in range(h):
        for x in range(w):
            if sum(pix[x,y])==0:
                grid[y][x] = "@"
            elif sum(pix[x,y]) in range(1,40):
                grid[y][x] = "N"
            elif sum(pix[x,y]) in range(40,80):
                grid[y][x] = "$"
            elif sum(pix[x,y]) in range(80,120):
                grid[y][x] = "m"
            elif sum(pix[x,y]) in range(120,160):
                grid[y][x] = "U"
            elif sum(pix[x,y]) in range(160,200):
                grid[y][x] = "V"
            elif sum(pix[x,y]) in range(200,240):
                grid[y][x] = "6"
            elif sum(pix[x,y]) in range(240,280):
                grid[y][x] = "S"
            elif sum(pix[x,y]) in range(280,320):
                grid[y][x] = "y"
            elif sum(pix[x,y]) in range(320,360):
                grid[y][x] = "Z"
            elif sum(pix[x,y]) in range(360,400):
                grid[y][x] = "u"
            elif sum(pix[x,y]) in range(400,440):
                grid[y][x] = "I"
            elif sum(pix[x,y]) in range(440,480):
                grid[y][x] = "i"
            elif sum(pix[x,y]) in range(480,520):
                grid[y][x] = "J"
            elif sum(pix[x,y]) in range(520,580):
                grid[y][x] = "s"
            elif sum(pix[x,y]) in range(580,620):
                grid[y][x] = "c"
            elif sum(pix[x,y]) in range(620,660):
                grid[y][x] = ">"
            elif sum(pix[x,y]) in range(660,700):
                grid[y][x] = "_"
            elif sum(pix[x,y]) in range(700,765):
                grid[y][x] = "`"
            else:
                grid[y][x] = " "
    
    art = open(saveas,"w")
    
    for row in grid:
        art.write("".join(row)+"\n")

    art.close()