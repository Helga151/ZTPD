let $doc := doc("db/bib/bib.xml")

(: zad 5 :)
(: return $doc//author/last :)

(: zad 6 :)
(: for $book in $doc//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    {$author}
    {$title}
  </ksiazka> :)

(: zad 7 :)
(: for $book in $doc//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    <autor>{$author/last/text()}{$author/first/text()}</autor>
    <tytul>{$title/text()}</tytul>
  </ksiazka> :)

(: zad 8 :)
(: for $book in $doc//book
for $title in $book/title
for $author in $book/author
return 
  <ksiazka>
    <autor>{concat($author/last/text(), ' ', $author/first/text())}</autor>
    <tytul>{$title/text()}</tytul>
  </ksiazka> :)

(: zad 9 :)
(: return
<wynik>
{ 
  for $book in $doc//book
  for $title in $book/title
  for $author in $book/author
  return 
      <ksiazka>
        <autor>{concat($author/last/text(), ' ', $author/first/text())}</autor>
        <tytul>{$title/text()}</tytul>
      </ksiazka>
}
</wynik> :)  

(: zad 10 :)
(: for $book in $doc//book
where $book/title = 'Data on the Web'
return 
  <imiona> {
  for $author in $book/author
  return 
      <imie>{$author/first/text()}</imie>
  }
  </imiona> :)

(: zad 11 :)
(: for $book in $doc//book[title = 'Data on the Web']
return 
<DataOnTheWeb>{$book}</DataOnTheWeb> :)

(: for $book in $doc//book
where $book/title = 'Data on the Web'
return 
<DataOnTheWeb>{$book}</DataOnTheWeb> :)
  
(: zad 12 :)
(: for $book in $doc//book
where contains($book/title, 'Data')
return 
<Data>{
for $author in $book/author
  return 
      <nazwisko>{$author/last/text()}</nazwisko>
}</Data> :)

(: zad 13 :)
(: for $book in $doc//book
where contains($book/title, 'Data')
return 
<Data>{$book/title}{
for $author in $book/author
  return 
      <nazwisko>{$author/last/text()}</nazwisko>
}</Data> :)

(: zad 14 :)
(: for $book in $doc//book
where count($book/author) <= 2
  return $book/title :)

(: zad 15 :)
(: for $book in $doc//book
return 
  <ksiazka>
    {$book/title}
    <autorow>{count($book/author)}</autorow>
  </ksiazka> :) 

(: zad 16 :)
(: let $min := min($doc//book/@year)
let $max := max($doc//book/@year)
return <przedział>{concat($min, ' - ', $max)}</przedział> :)

(: zad 17 :)
(: let $min := min($doc//book/price)
let $max := max($doc//book/price)
return <różnica>{$max - $min}</różnica> :)

(: zad 18 :)
(: let $min := min($doc//book/price)

return <najtańsze> {
  for $book in $doc//book[price = $min]
  return <najtańsza> {
    $book/title,
    $book/author
    } </najtańsza>
} </najtańsze> :)

(: zad 19 :)
for $author in distinct-values($doc//author)
let $title := $doc//book[author = $author]/title
return <autor> 
  {$author}
  {$title}
</autor>