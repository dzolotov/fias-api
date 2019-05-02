#!/bin/bash
export AQUEDUCT_DIR=$HOME/.pub-cache/hosted/pub.dartlang.org/aqueduct-3.2.1/lib/
cp patch/attributes.dart $AQUEDUCT_DIR/src/db/managed/attributes.dart
cp patch/property_builder.dart $AQUEDUCT_DIR/src/db/managed/builders/property_builder.dart
cp patch/property_description.dart $AQUEDUCT_DIR/src/db/managed/property_description.dart
cp patch/resource_controller_bindings.dart $AQUEDUCT_DIR/src/http/resource_controller_bindings.dart
cp patch/method.dart $AQUEDUCT_DIR/src/http/resource_controller_internal/method.dart
cp patch/postgresql_persistent_store.dart $AQUEDUCT_DIR/src/db/postgresql/postgresql_persistent_store.dart
