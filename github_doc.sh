make html
rm -rf ./docs/
cp -a ./build/html/ docs/
touch ./docs/.nojekyll
