function [kod,slownik,zdekodowany]=HUFF(tekst)

global ZAKODOWANE_ZNAKI    %zmienne globalne potrzebne do wymiany danych z funckj� 'kodowanie'   
global ii
ii=0;


bez_powt=unique(tekst);     

if (length(bez_powt)>1) %dla kodu zawieraj�cego te same znaki specjalny przypadek
    
for i=1:length(bez_powt)    
    ilosc_znakow(i) = length(find(tekst == bez_powt(i))); %ilosc poszczegolnych znakow w tekscie
    znaki{i} = bez_powt(i);  
end

[ilosc_znakow, index]=sort(ilosc_znakow);       %Sortowanie znakow i wystapien
for i=1:length(index)
    posortowane_znaki{i}=znaki{index(i)};
end

l_znak=ilosc_znakow;


drzewo = cell(length(ilosc_znakow), 1);

%{
for i = 1:length(ilosc_znakow)
   drzewo{i} = i;              
end
%}

while length(ilosc_znakow) > 2
   [ilosc_znakow, index] = sort(ilosc_znakow);       %Sortowanie ilosci wystapien znakow
   ilosc_znakow(2) = ilosc_znakow(1) + ilosc_znakow(2);   %Dodanie dwoch najmniejszych
   ilosc_znakow(1) = [];                                %Kasowanie komorki zawierajacej mniejsza liczbe
   
   drzewo = drzewo(index);                  %Sortowanie drzewa
   drzewo{2} = {drzewo{1}, drzewo{2}}; 
   drzewo(1) = [];           
end

kodowanie(drzewo, [])     %wywolanie rekurencyjnej funkcji generujacej kod na podstawie tablicy 'drzewo'

for i=1:length(tekst)               
    for k=1:length(posortowane_znaki)       %petla sprawdzajaca po kolei znaki we wprowadzonym tekscie
        if posortowane_znaki{k} == tekst(i)     %i tworzaca tablice odpowiadajacych im kodow
            kod{i} = ZAKODOWANE_ZNAKI{k};
            break
        end
    end
end

else          %wystepuje tylko 1 rodzaj znakow; przypadek specjalny
    for i=1:length(tekst)       
        posortowane_znaki{i}=bez_powt;  
        ZAKODOWANE_ZNAKI{i}=('1');      %przypisujemy "na sztywno" jedynke
    end
    l_znak=1;
    kod=ZAKODOWANE_ZNAKI;
end

zdekodowany=dekodowanie(kod, posortowane_znaki);


%%% ustalanie "s�ownika" zakodowanych znak�w na podstawie wprowadzonego ci�gu
for i=1:length(l_znak)
    l_znakk(i)={l_znak(i)};     %dopasowanie formatu macierzy
end

slownik(:,1)=(posortowane_znaki)';
slownik(:,2)=(ZAKODOWANE_ZNAKI)';
slownik(:,3)=(l_znakk);
end
