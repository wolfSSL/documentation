from BeautifulSoup import BeautifulSoup
from HTMLParser import HTMLParser
import clang.cindex, asciitree, sys, ntpath, unicodedata, re

'''
You'll need clang and Beautiful Soup. Designed for Python 2

This extracts our documentation for the HTML exported from the google documentation
Subsequently it compiles and parses the file file passed in from the command line e.g. .../src/ssl.c
Then it attempts to match function in the docs with the definition in the file.

clang python wrapper documentation is terrible, good luck.
'''

h = HTMLParser()
def match_class(target):
    '''Stolen from some comment on StackOverflow, matches by a classname'''
    def do_match(tag):                                                          
        classes = tag.get('class', [])                                          
        return all(c in classes for c in target)                                
    return do_match

def findStuff():
    html_page = open('API.html').read() #get raw html from page, destroys whitespace
    soup = BeautifulSoup(html_page) #This package is amazing
    res = soup.findAll('h3')
    res2 = soup.findAll(text='Description:')
    res2_final=[]
    for m in res2:
        des = unicodedata.normalize('NFKD', h.unescape(loopUntil('', m))).encode('ascii','ignore')
        res2_final.append(des)
    res = [unicodedata.normalize('NFKD', h.unescape(m.text)).encode('ascii','ignore') for m in res]
    tups = []
    for i in range(min(len(res),len(res2_final))):
        tups.append( (res[i], res2_final[i]) )
    return tups

def loopUntil(text, firstElement):
    t = unicode(getattr(firstElement,'text',None))
    if t != 'None' and not t is None:
        text += t
    if (getattr(firstElement.next.next,'text',None) == "Return Values:"):             
        return text
    else:
        return loopUntil(text, firstElement.next.next)

def cursorToLst(n):
    loc = str(n.location)
    splat = loc.split(',')
    fl = splat[0][splat[0].rfind('/'):-1]
    splat[2]=splat[2][:-1]
    return [(n.displayname or n.spelling),
    str(n.type.kind),
    str(n.kind).split(".")[1],
    fl,
    splat[1].strip(),
    splat[2].strip(),
    str(n.is_definition())] 

'''Oh yes, that recursion'''
def getTree(n,lst):
    lst.append(cursorToLst(n))
    [getTree(i,lst) for i in n.get_children()]

'''Find all the function declarations in the files'''
def getFuncs():
    clang.cindex.Config.set_library_path('/Library/Developer/CommandLineTools/usr/lib/')
    index = clang.cindex.Index(clang.cindex.conf.lib.clang_createIndex(False, True))
    translation_unit = index.parse(sys.argv[1],['-I../wolfssl/'])
    mat=[]
    getTree(translation_unit.cursor,mat)
    i = 0;
    tups=[]
    for line in mat:
        if (line[2] == 'FUNCTION_DECL' and line[6]=='True' and line[3]=='/'+ntpath.basename(sys.argv[1])):
            tups.append( (line[0][0:line[0].find('(')],line[4]) )
    return tups

'''Example, let's you input a name of a function and it will match it'''
def interactive():
    docs = dict(findStuff())
    funcs = dict(getFuncs())
    print '$quit to quit'
    while 1:
        put = raw_input("Func name:")
        if(put in docs):print "Description:",docs[put]
        if(put in funcs):print funcs[put]
        if put =='$quit':break

if __name__=='__main__':
    interactive()
