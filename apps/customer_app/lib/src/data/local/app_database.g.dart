// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedProductsTable extends CachedProducts
    with TableInfo<$CachedProductsTable, CachedProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uomMeta = const VerificationMeta('uom');
  @override
  late final GeneratedColumn<String> uom = GeneratedColumn<String>(
    'uom',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packSizeMeta = const VerificationMeta(
    'packSize',
  );
  @override
  late final GeneratedColumn<double> packSize = GeneratedColumn<double>(
    'pack_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromPricePaiseMeta = const VerificationMeta(
    'fromPricePaise',
  );
  @override
  late final GeneratedColumn<int> fromPricePaise = GeneratedColumn<int>(
    'from_price_paise',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSubscribableMeta = const VerificationMeta(
    'isSubscribable',
  );
  @override
  late final GeneratedColumn<bool> isSubscribable = GeneratedColumn<bool>(
    'is_subscribable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_subscribable" IN (0, 1))',
    ),
  );
  static const VerificationMeta _perishableMeta = const VerificationMeta(
    'perishable',
  );
  @override
  late final GeneratedColumn<bool> perishable = GeneratedColumn<bool>(
    'perishable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("perishable" IN (0, 1))',
    ),
  );
  static const VerificationMeta _avgRatingMeta = const VerificationMeta(
    'avgRating',
  );
  @override
  late final GeneratedColumn<double> avgRating = GeneratedColumn<double>(
    'avg_rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingCountMeta = const VerificationMeta(
    'ratingCount',
  );
  @override
  late final GeneratedColumn<int> ratingCount = GeneratedColumn<int>(
    'rating_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sku,
    name,
    description,
    category,
    uom,
    packSize,
    fromPricePaise,
    imageUrl,
    isSubscribable,
    perishable,
    avgRating,
    ratingCount,
    position,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedProduct> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('uom')) {
      context.handle(
        _uomMeta,
        uom.isAcceptableOrUnknown(data['uom']!, _uomMeta),
      );
    } else if (isInserting) {
      context.missing(_uomMeta);
    }
    if (data.containsKey('pack_size')) {
      context.handle(
        _packSizeMeta,
        packSize.isAcceptableOrUnknown(data['pack_size']!, _packSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_packSizeMeta);
    }
    if (data.containsKey('from_price_paise')) {
      context.handle(
        _fromPricePaiseMeta,
        fromPricePaise.isAcceptableOrUnknown(
          data['from_price_paise']!,
          _fromPricePaiseMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_subscribable')) {
      context.handle(
        _isSubscribableMeta,
        isSubscribable.isAcceptableOrUnknown(
          data['is_subscribable']!,
          _isSubscribableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isSubscribableMeta);
    }
    if (data.containsKey('perishable')) {
      context.handle(
        _perishableMeta,
        perishable.isAcceptableOrUnknown(data['perishable']!, _perishableMeta),
      );
    } else if (isInserting) {
      context.missing(_perishableMeta);
    }
    if (data.containsKey('avg_rating')) {
      context.handle(
        _avgRatingMeta,
        avgRating.isAcceptableOrUnknown(data['avg_rating']!, _avgRatingMeta),
      );
    } else if (isInserting) {
      context.missing(_avgRatingMeta);
    }
    if (data.containsKey('rating_count')) {
      context.handle(
        _ratingCountMeta,
        ratingCount.isAcceptableOrUnknown(
          data['rating_count']!,
          _ratingCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ratingCountMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedProduct(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      uom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uom'],
      )!,
      packSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pack_size'],
      )!,
      fromPricePaise: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_price_paise'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isSubscribable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_subscribable'],
      )!,
      perishable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}perishable'],
      )!,
      avgRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_rating'],
      )!,
      ratingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating_count'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedProductsTable createAlias(String alias) {
    return $CachedProductsTable(attachedDatabase, alias);
  }
}

class CachedProduct extends DataClass implements Insertable<CachedProduct> {
  final int id;
  final String sku;
  final String name;
  final String? description;
  final String? category;
  final String uom;
  final double packSize;
  final int? fromPricePaise;
  final String? imageUrl;
  final bool isSubscribable;
  final bool perishable;
  final double avgRating;
  final int ratingCount;

  /// Server order, so the offline list looks like the online one.
  final int position;
  final DateTime fetchedAt;
  const CachedProduct({
    required this.id,
    required this.sku,
    required this.name,
    this.description,
    this.category,
    required this.uom,
    required this.packSize,
    this.fromPricePaise,
    this.imageUrl,
    required this.isSubscribable,
    required this.perishable,
    required this.avgRating,
    required this.ratingCount,
    required this.position,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sku'] = Variable<String>(sku);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['uom'] = Variable<String>(uom);
    map['pack_size'] = Variable<double>(packSize);
    if (!nullToAbsent || fromPricePaise != null) {
      map['from_price_paise'] = Variable<int>(fromPricePaise);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_subscribable'] = Variable<bool>(isSubscribable);
    map['perishable'] = Variable<bool>(perishable);
    map['avg_rating'] = Variable<double>(avgRating);
    map['rating_count'] = Variable<int>(ratingCount);
    map['position'] = Variable<int>(position);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedProductsCompanion toCompanion(bool nullToAbsent) {
    return CachedProductsCompanion(
      id: Value(id),
      sku: Value(sku),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      uom: Value(uom),
      packSize: Value(packSize),
      fromPricePaise: fromPricePaise == null && nullToAbsent
          ? const Value.absent()
          : Value(fromPricePaise),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isSubscribable: Value(isSubscribable),
      perishable: Value(perishable),
      avgRating: Value(avgRating),
      ratingCount: Value(ratingCount),
      position: Value(position),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedProduct.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedProduct(
      id: serializer.fromJson<int>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      category: serializer.fromJson<String?>(json['category']),
      uom: serializer.fromJson<String>(json['uom']),
      packSize: serializer.fromJson<double>(json['packSize']),
      fromPricePaise: serializer.fromJson<int?>(json['fromPricePaise']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isSubscribable: serializer.fromJson<bool>(json['isSubscribable']),
      perishable: serializer.fromJson<bool>(json['perishable']),
      avgRating: serializer.fromJson<double>(json['avgRating']),
      ratingCount: serializer.fromJson<int>(json['ratingCount']),
      position: serializer.fromJson<int>(json['position']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sku': serializer.toJson<String>(sku),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'category': serializer.toJson<String?>(category),
      'uom': serializer.toJson<String>(uom),
      'packSize': serializer.toJson<double>(packSize),
      'fromPricePaise': serializer.toJson<int?>(fromPricePaise),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isSubscribable': serializer.toJson<bool>(isSubscribable),
      'perishable': serializer.toJson<bool>(perishable),
      'avgRating': serializer.toJson<double>(avgRating),
      'ratingCount': serializer.toJson<int>(ratingCount),
      'position': serializer.toJson<int>(position),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedProduct copyWith({
    int? id,
    String? sku,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> category = const Value.absent(),
    String? uom,
    double? packSize,
    Value<int?> fromPricePaise = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    bool? isSubscribable,
    bool? perishable,
    double? avgRating,
    int? ratingCount,
    int? position,
    DateTime? fetchedAt,
  }) => CachedProduct(
    id: id ?? this.id,
    sku: sku ?? this.sku,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    category: category.present ? category.value : this.category,
    uom: uom ?? this.uom,
    packSize: packSize ?? this.packSize,
    fromPricePaise: fromPricePaise.present
        ? fromPricePaise.value
        : this.fromPricePaise,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isSubscribable: isSubscribable ?? this.isSubscribable,
    perishable: perishable ?? this.perishable,
    avgRating: avgRating ?? this.avgRating,
    ratingCount: ratingCount ?? this.ratingCount,
    position: position ?? this.position,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedProduct copyWithCompanion(CachedProductsCompanion data) {
    return CachedProduct(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      uom: data.uom.present ? data.uom.value : this.uom,
      packSize: data.packSize.present ? data.packSize.value : this.packSize,
      fromPricePaise: data.fromPricePaise.present
          ? data.fromPricePaise.value
          : this.fromPricePaise,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isSubscribable: data.isSubscribable.present
          ? data.isSubscribable.value
          : this.isSubscribable,
      perishable: data.perishable.present
          ? data.perishable.value
          : this.perishable,
      avgRating: data.avgRating.present ? data.avgRating.value : this.avgRating,
      ratingCount: data.ratingCount.present
          ? data.ratingCount.value
          : this.ratingCount,
      position: data.position.present ? data.position.value : this.position,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedProduct(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('uom: $uom, ')
          ..write('packSize: $packSize, ')
          ..write('fromPricePaise: $fromPricePaise, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isSubscribable: $isSubscribable, ')
          ..write('perishable: $perishable, ')
          ..write('avgRating: $avgRating, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('position: $position, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sku,
    name,
    description,
    category,
    uom,
    packSize,
    fromPricePaise,
    imageUrl,
    isSubscribable,
    perishable,
    avgRating,
    ratingCount,
    position,
    fetchedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedProduct &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.uom == this.uom &&
          other.packSize == this.packSize &&
          other.fromPricePaise == this.fromPricePaise &&
          other.imageUrl == this.imageUrl &&
          other.isSubscribable == this.isSubscribable &&
          other.perishable == this.perishable &&
          other.avgRating == this.avgRating &&
          other.ratingCount == this.ratingCount &&
          other.position == this.position &&
          other.fetchedAt == this.fetchedAt);
}

class CachedProductsCompanion extends UpdateCompanion<CachedProduct> {
  final Value<int> id;
  final Value<String> sku;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> category;
  final Value<String> uom;
  final Value<double> packSize;
  final Value<int?> fromPricePaise;
  final Value<String?> imageUrl;
  final Value<bool> isSubscribable;
  final Value<bool> perishable;
  final Value<double> avgRating;
  final Value<int> ratingCount;
  final Value<int> position;
  final Value<DateTime> fetchedAt;
  const CachedProductsCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.uom = const Value.absent(),
    this.packSize = const Value.absent(),
    this.fromPricePaise = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isSubscribable = const Value.absent(),
    this.perishable = const Value.absent(),
    this.avgRating = const Value.absent(),
    this.ratingCount = const Value.absent(),
    this.position = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  CachedProductsCompanion.insert({
    this.id = const Value.absent(),
    required String sku,
    required String name,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    required String uom,
    required double packSize,
    this.fromPricePaise = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required bool isSubscribable,
    required bool perishable,
    required double avgRating,
    required int ratingCount,
    required int position,
    required DateTime fetchedAt,
  }) : sku = Value(sku),
       name = Value(name),
       uom = Value(uom),
       packSize = Value(packSize),
       isSubscribable = Value(isSubscribable),
       perishable = Value(perishable),
       avgRating = Value(avgRating),
       ratingCount = Value(ratingCount),
       position = Value(position),
       fetchedAt = Value(fetchedAt);
  static Insertable<CachedProduct> custom({
    Expression<int>? id,
    Expression<String>? sku,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? uom,
    Expression<double>? packSize,
    Expression<int>? fromPricePaise,
    Expression<String>? imageUrl,
    Expression<bool>? isSubscribable,
    Expression<bool>? perishable,
    Expression<double>? avgRating,
    Expression<int>? ratingCount,
    Expression<int>? position,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (uom != null) 'uom': uom,
      if (packSize != null) 'pack_size': packSize,
      if (fromPricePaise != null) 'from_price_paise': fromPricePaise,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isSubscribable != null) 'is_subscribable': isSubscribable,
      if (perishable != null) 'perishable': perishable,
      if (avgRating != null) 'avg_rating': avgRating,
      if (ratingCount != null) 'rating_count': ratingCount,
      if (position != null) 'position': position,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  CachedProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? sku,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? category,
    Value<String>? uom,
    Value<double>? packSize,
    Value<int?>? fromPricePaise,
    Value<String?>? imageUrl,
    Value<bool>? isSubscribable,
    Value<bool>? perishable,
    Value<double>? avgRating,
    Value<int>? ratingCount,
    Value<int>? position,
    Value<DateTime>? fetchedAt,
  }) {
    return CachedProductsCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      uom: uom ?? this.uom,
      packSize: packSize ?? this.packSize,
      fromPricePaise: fromPricePaise ?? this.fromPricePaise,
      imageUrl: imageUrl ?? this.imageUrl,
      isSubscribable: isSubscribable ?? this.isSubscribable,
      perishable: perishable ?? this.perishable,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      position: position ?? this.position,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (uom.present) {
      map['uom'] = Variable<String>(uom.value);
    }
    if (packSize.present) {
      map['pack_size'] = Variable<double>(packSize.value);
    }
    if (fromPricePaise.present) {
      map['from_price_paise'] = Variable<int>(fromPricePaise.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isSubscribable.present) {
      map['is_subscribable'] = Variable<bool>(isSubscribable.value);
    }
    if (perishable.present) {
      map['perishable'] = Variable<bool>(perishable.value);
    }
    if (avgRating.present) {
      map['avg_rating'] = Variable<double>(avgRating.value);
    }
    if (ratingCount.present) {
      map['rating_count'] = Variable<int>(ratingCount.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedProductsCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('uom: $uom, ')
          ..write('packSize: $packSize, ')
          ..write('fromPricePaise: $fromPricePaise, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isSubscribable: $isSubscribable, ')
          ..write('perishable: $perishable, ')
          ..write('avgRating: $avgRating, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('position: $position, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedProductsTable cachedProducts = $CachedProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cachedProducts];
}

typedef $$CachedProductsTableCreateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<int> id,
      required String sku,
      required String name,
      Value<String?> description,
      Value<String?> category,
      required String uom,
      required double packSize,
      Value<int?> fromPricePaise,
      Value<String?> imageUrl,
      required bool isSubscribable,
      required bool perishable,
      required double avgRating,
      required int ratingCount,
      required int position,
      required DateTime fetchedAt,
    });
typedef $$CachedProductsTableUpdateCompanionBuilder =
    CachedProductsCompanion Function({
      Value<int> id,
      Value<String> sku,
      Value<String> name,
      Value<String?> description,
      Value<String?> category,
      Value<String> uom,
      Value<double> packSize,
      Value<int?> fromPricePaise,
      Value<String?> imageUrl,
      Value<bool> isSubscribable,
      Value<bool> perishable,
      Value<double> avgRating,
      Value<int> ratingCount,
      Value<int> position,
      Value<DateTime> fetchedAt,
    });

class $$CachedProductsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromPricePaise => $composableBuilder(
    column: $table.fromPricePaise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSubscribable => $composableBuilder(
    column: $table.isSubscribable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get perishable => $composableBuilder(
    column: $table.perishable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgRating => $composableBuilder(
    column: $table.avgRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uom => $composableBuilder(
    column: $table.uom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromPricePaise => $composableBuilder(
    column: $table.fromPricePaise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSubscribable => $composableBuilder(
    column: $table.isSubscribable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get perishable => $composableBuilder(
    column: $table.perishable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgRating => $composableBuilder(
    column: $table.avgRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedProductsTable> {
  $$CachedProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get uom =>
      $composableBuilder(column: $table.uom, builder: (column) => column);

  GeneratedColumn<double> get packSize =>
      $composableBuilder(column: $table.packSize, builder: (column) => column);

  GeneratedColumn<int> get fromPricePaise => $composableBuilder(
    column: $table.fromPricePaise,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isSubscribable => $composableBuilder(
    column: $table.isSubscribable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get perishable => $composableBuilder(
    column: $table.perishable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgRating =>
      $composableBuilder(column: $table.avgRating, builder: (column) => column);

  GeneratedColumn<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedProductsTable,
          CachedProduct,
          $$CachedProductsTableFilterComposer,
          $$CachedProductsTableOrderingComposer,
          $$CachedProductsTableAnnotationComposer,
          $$CachedProductsTableCreateCompanionBuilder,
          $$CachedProductsTableUpdateCompanionBuilder,
          (
            CachedProduct,
            BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
          ),
          CachedProduct,
          PrefetchHooks Function()
        > {
  $$CachedProductsTableTableManager(
    _$AppDatabase db,
    $CachedProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> uom = const Value.absent(),
                Value<double> packSize = const Value.absent(),
                Value<int?> fromPricePaise = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isSubscribable = const Value.absent(),
                Value<bool> perishable = const Value.absent(),
                Value<double> avgRating = const Value.absent(),
                Value<int> ratingCount = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CachedProductsCompanion(
                id: id,
                sku: sku,
                name: name,
                description: description,
                category: category,
                uom: uom,
                packSize: packSize,
                fromPricePaise: fromPricePaise,
                imageUrl: imageUrl,
                isSubscribable: isSubscribable,
                perishable: perishable,
                avgRating: avgRating,
                ratingCount: ratingCount,
                position: position,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sku,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> category = const Value.absent(),
                required String uom,
                required double packSize,
                Value<int?> fromPricePaise = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                required bool isSubscribable,
                required bool perishable,
                required double avgRating,
                required int ratingCount,
                required int position,
                required DateTime fetchedAt,
              }) => CachedProductsCompanion.insert(
                id: id,
                sku: sku,
                name: name,
                description: description,
                category: category,
                uom: uom,
                packSize: packSize,
                fromPricePaise: fromPricePaise,
                imageUrl: imageUrl,
                isSubscribable: isSubscribable,
                perishable: perishable,
                avgRating: avgRating,
                ratingCount: ratingCount,
                position: position,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CachedProductsTable, CachedProduct>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CachedProductsTable,
                    CachedProduct
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedProductsTable,
      CachedProduct,
      $$CachedProductsTableFilterComposer,
      $$CachedProductsTableOrderingComposer,
      $$CachedProductsTableAnnotationComposer,
      $$CachedProductsTableCreateCompanionBuilder,
      $$CachedProductsTableUpdateCompanionBuilder,
      (
        CachedProduct,
        BaseReferences<_$AppDatabase, $CachedProductsTable, CachedProduct>,
      ),
      CachedProduct,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedProductsTableTableManager get cachedProducts =>
      $$CachedProductsTableTableManager(_db, _db.cachedProducts);
}
