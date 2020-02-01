#!/usr/bin/env bash

# shell is funny

function apply_app() {
    if [[ ${1}} == "all" ]]; then
        kubectl create -f ./ -R
    fi
    if [[ -f ${1} ]]; then
        kubectl delete -f ${1}
        kubectl apply -f ${1};return
    fi
    if [[ -d ${1} ]]; then
        kubectl delete -f ${1}/${1}.yaml
        kubectl apply -f ${1}/${1}.yaml
    else
        echo "No found application：${2}";exit 1;
    fi
}

function replace_app() {
    if [[ ${1}} == "all" ]]; then
        kubectl replace -f ./ -R --force
    fi
    if [[ -f ${1} ]]; then
        kubectl replace -f ${1};return
    fi
    if [[ -d ${1} ]]; then
        kubectl replace -f ${1}/${1}.yaml
    else
        echo "No found application：${2}";exit 1;
    fi
}

function delete_app() {
    if [[ ${1}} == "all" ]]; then
        kubectl delete -f ./ -R
    fi
    if [[ -f ${1} ]]; then
        kubectl delete -f ${1};return
    fi
    if [[ -d ${1} ]]; then
        kubectl delete -f ${1}/${1}.yaml
    else
        echo "No found application：${2}";exit 1;
    fi
}

case ${1} in
    apply)
        apply_app ${2};exit;;
    replace)
        replace_app ${2};exit;;
    delete)
        delete_app ${2};exit;;
    *)
        echo -e "\n`basename ${0}`:Usage: [OPTIONS]\n"
        echo -e "Options:"
        echo -e "\t -a, apply filename \t Apply pod"
        echo -e "\t -r, replace filename \t Replace pod"
        echo -e "\t -d, delete filename \t Delete pod"
        echo
        exit 1;;
esac
