import 'dart:async';
import 'dart:convert';

import 'package:udevs_video_player/models/download_configuration.dart';
import 'package:udevs_video_player/models/media_item_download.dart';
import 'package:udevs_video_player/models/player_configuration.dart';

import 'udevs_video_player_platform_interface.dart';

export 'package:udevs_video_player/models/download_configuration.dart';
export 'package:udevs_video_player/models/media_item_download.dart';
export 'package:udevs_video_player/models/movie.dart';
export 'package:udevs_video_player/models/player_configuration.dart';
export 'package:udevs_video_player/models/programs_info.dart';
export 'package:udevs_video_player/models/season.dart';
export 'package:udevs_video_player/models/tv_program.dart';

class UdevsVideoPlayer {
  factory UdevsVideoPlayer() => _instance;

  UdevsVideoPlayer._();

  static final UdevsVideoPlayer _instance = UdevsVideoPlayer._();

  Future<int?> playVideo({required PlayerConfiguration playerConfig}) {
    // final String jsonStringConfig = jsonEncode(playerConfig.toJson());
    final String jsonStringConfig = jsonEncode({
      'initialResolution': {
        'Автонастройка':
        'https://st1.uzdigital.tv/Setanta1HD/video.m3u8?token=316ee910a8ba3e654e262f580299fc93f0367a3b-41666c6b50654d5a7a62747149497458-1695113748-1695102948&remote=94.232.24.122'
      },
      'resolutions': {
        'Автонастройка':
        'https://st1.uzdigital.tv/Setanta1HD/video.m3u8?token=316ee910a8ba3e654e262f580299fc93f0367a3b-41666c6b50654d5a7a62747149497458-1695113748-1695102948&remote=94.232.24.122',
        '1080p':
        'http://st1.uzdigital.tv/Setanta1HD/tracks-v1a1a2/mono.m3u8?remote=94.232.24.122&token=316ee910a8ba3e654e262f580299fc93f0367a3b-41666c6b50654d5a7a62747149497458-1695113748-1695102948&remote=94.232.24.122',
        '576p':
        'http://st1.uzdigital.tv/Setanta1HD/tracks-v2a1a2/mono.m3u8?remote=94.232.24.122&token=316ee910a8ba3e654e262f580299fc93f0367a3b-41666c6b50654d5a7a62747149497458-1695113748-1695102948&remote=94.232.24.122'
      },
      'qualityText': 'Качество',
      'speedText': 'Скорость воспроизведения',
      'lastPosition': 0,
      'title': 'Setanta Sports 1',
      'isSerial': false,
      'episodeButtonText': '',
      'nextButtonText': '',
      'seasons': [],
      'isLive': true,
      'tvProgramsText': 'Телепередачи',
      'programsInfoList': [
        {
          'day': 'Вчера',
          'tvPrograms': [
            {'scheduledTime': '17:00', 'programTitle': 'Программа отсутствует.'}
          ]
        },
        {'day': 'Сегодня', 'tvPrograms': []},
        {'day': 'Завтра', 'tvPrograms': []}
      ],
      'showController': true,
      'playVideoFromAsset': false,
      'assetPath': '',
      'seasonIndex': 0,
      'episodeIndex': 0,
      'isMegogo': false,
      'isPremier': false,
      'isMoreTv': false,
      'videoId': '',
      'sessionId': '65092979d80dc5f8a11f9e98',
      'megogoAccessToken': '',
      'authorization':
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2ODY1NTk5MDIsImlzcyI6InVzZXIiLCJwaWQiOjc2MDY2LCJyb2xlIjoiY3VzdG9tZXIiLCJzdWIiOiI4YzUyNmFiZC0yZDBhLTQ1YzEtYjUyNy04MTRmOTliNWYwNDAifQ.ffXIBxI693pcaZmMrXNWEa_HrvYO_waN77FzBLbryUI',
      'autoText': 'Автонастройка',
      'baseUrl': 'https://api.spec.uzd.udevs.io/v1/',
      'fromCache': false,
      'movieShareLink': '',
      'ip': '89.236.205.221',
      'selectChannelIndex': 0,
      'selectTvCategoryIndex': 0,
      'tvCategories': [
        {
          'id': '',
          'title': 'Все',
          'tvChannels': [
            {
              'id': 'c782939d-2ace-4075-96d1-c3eae0162370',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/1738fe23-f629-4a69-ae16-617cf61fcf9d.png',
              'name': 'Setanta Sports 1',
              'resolutions': {}
            },
            {
              'id': '8fd99b87-936c-47f6-8874-dda03521d69a',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/af462c3d-7a33-4355-b0a5-838dcd77aa8e.png',
              'name': 'Setanta Sports 2',
              'resolutions': {}
            },
            {
              'id': 'eff25037-a336-49a0-9ff9-78ed665c8df5',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/49a693c3-2c6b-4d20-ae2d-48e2e063fb9f.png',
              'name': 'CNN',
              'resolutions': {}
            },
            {
              'id': '107edbec-1dfe-4c84-ae67-aae7ea4dfe77',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/bdd69ce9-8186-45a6-914a-4c992c5ea201.png',
              'name': 'Sport UZ',
              'resolutions': {}
            },
            {
              'id': 'e021050d-fdf1-4360-a913-992371d16c8e',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/f488b5f9-fc93-40b0-9394-200df5974fad.png',
              'name': 'Россия 1',
              'resolutions': {}
            },
            {
              'id': '36161291-fe63-4c4c-94c9-f7bd1e1701a3',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/0fe75735-1f53-4018-88ea-e8a569018b2b.png',
              'name': 'Uzreport',
              'resolutions': {}
            },
            {
              'id': '0b9d5e0e-ba91-4fb9-af78-be1ff21f349d',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/9a264d6d-ac23-452c-b83d-12127bb6f647.png',
              'name': 'Россия Культура',
              'resolutions': {}
            },
            {
              'id': '7445a97b-4016-4030-985c-409a61b54eea',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/21a8e0a8-81f1-43ff-9882-4223dfb1b047.png',
              'name': 'Россия 24',
              'resolutions': {}
            },
            {
              'id': 'b4e0e6ef-b715-4bd0-b7f5-8d6055833053',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/c081f296-5b49-4ec6-bdfa-21920011a4c9.png',
              'name': 'Первый канал',
              'resolutions': {}
            },
            {
              'id': '73d9ac33-f2d5-4329-927f-44e44ad38859',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/10a97582-3389-4ecc-bd93-c00a8bdae5f4.png',
              'name': 'РБК',
              'resolutions': {}
            },
            {
              'id': 'eb97a18f-ef84-4d38-9604-69236e8db4ce',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/e14d6851-3de2-4f1a-b98c-4f899303d476.png',
              'name': 'НТВ',
              'resolutions': {}
            },
            {
              'id': 'f3868ebe-a64a-4bb9-bc1f-a4932979d2b0',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/2fea5c06-adbf-415d-870f-d8a18a268bec.png',
              'name': 'НТВ  Hayotbek Mirzaqosimov Udevs, [19/09/23 11:01] мир',
              'resolutions': {}
            },
            {
              'id': '223682b1-2c84-471b-bbfa-cce4feeff14d',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/3a5e0f7a-30ab-4556-becd-362d73bbaa38.png',
              'name': 'Euronews',
              'resolutions': {}
            },
            {
              'id': '7234a93d-36bc-4cce-a36c-ee32d593dc65',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/48dd9cb8-f840-4b31-9847-74d49cd25feb.png',
              'name': 'Eurosport 1',
              'resolutions': {}
            },
            {
              'id': '7dbc7299-9852-4907-bdfa-1e2a0b268327',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/fb9f2e84-07db-4868-a214-0c49de9e06f1.png',
              'name': 'BBC World News',
              'resolutions': {}
            },
            {
              'id': '6d6416dd-b4bd-42d2-b3e2-794a0668b7c9',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/38f08157-bd3c-49cf-bf58-fd056ff6f37e.png',
              'name': 'Мужское кино HD',
              'resolutions': {}
            },
            {
              'id': 'b130f49e-1c3e-4e3e-9876-8ee2a010af0b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/994215ce-673f-4141-86bc-36cc465bb173.png',
              'name': 'Киномикс HD',
              'resolutions': {}
            },
            {
              'id': '816ae22c-0b7b-46e8-84a9-31cb295fc7f1',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/51ab8e5b-7ad0-4d15-9626-2893124f91cc.png',
              'name': 'Кинопремьера',
              'resolutions': {}
            },
            {
              'id': '1d904a00-7953-4aab-a2d2-953cbe8fc13b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/1fe3d77b-517b-4016-b1d0-3532555b8c73.png',
              'name': 'Киносвидание',
              'resolutions': {}
            },
            {
              'id': '66fb17dc-b8f7-4c91-afa6-fe2bb649bcee',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/e6587af0-1b67-4b7c-8c0c-b0f220591527.png',
              'name': 'Кинокомедия',
              'resolutions': {}
            },
            {
              'id': 'ff1826f8-c4a0-4995-8bf5-c27c850fb252',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/d5c3e4c9-503a-408c-8f18-cf396530ff85.png',
              'name': 'Киносемья',
              'resolutions': {}
            },
            {
              'id': '03d7ebed-7eb3-4a58-bb6d-8a2d0f3c8996',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/2f8aa15c-516a-4be4-9fb7-a82461f41354.png',
              'name': 'Кинохит',
              'resolutions': {}
            },
            {
              'id': 'bea0d9b8-92fb-4fdf-97a6-3820f0c798ef',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/16bbcf0f-bb8a-4d68-ae6c-4f3c118d656f.png',
              'name': 'Наше новое кино',
              'resolutions': {}
            },
            {
              'id': '0e350a24-b892-49fd-844f-75a859c2945f',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/e197355e-7342-4d78-b279-9014913e7d03.png',
              'name': 'Родное кино',
              'resolutions': {}
            },
            {
              'id': 'bf070086-d6ed-483e-a926-1eb429a2e625',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/272e77f4-d996-4342-9010-48933802052f.png',
              'name': 'Киносерия',
              'resolutions': {}
            },
            {
              'id': 'eace2214-2a77-4250-9f70-4bea5e3842da',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/87a3398c-dfa1-4154-9ce1-de6c2c4f4985.png',
              'name': 'Индийское кино',
              'resolutions': {}
            },
            {
              'id': '4a39aa86-471b-484d-a230-fad2175a54ae',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/7f362853-9bbb-4ecf-95e3-adbebfbf43e4.png',
              'name': 'ViP Megahit',
              'resolutions': {}
            },
            {
              'id': '114d01b5-ebbf-4499-9f5f-85c5afd156d6',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/a236af15-7573-43d3-ac0e-594a0e4f670d.png',
              'name': 'ViP Premiere',
              'resolutions': {}
            },
            {
              'id': '1bf8de0a-7fc9-4eae-ab30-55da4ba6a475',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/b6e94d97-75c5-4bc1-9398-748b95dcac92.png',
              'name': 'CINEMA HD',
              'resolutions': {}
            },
            {
              'id': '2c1cf6dc-5a1c-41c6-9ec4-10a064793f2c',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/b58ea404-fa21-4f11-ab73-b3c73ef93319.png',
              'name': 'ТВ1000',
              'resolutions': {}
            },
            {
              'id': '9d9515d6-97b6-45af-ad6e-e1badf83aa1f',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/f9dbd777-d72b-4ae0-930b-1d713730d482.png',
              'name': 'TV 1000 Русское кино',
              'resolutions': {}
            },
            {
              'id': '92a7f8ff-8ee6-4b88-abfd-d91177a31f62',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/a29be9f3-b375-49ba-b809-545188e9f4d6.png',
              'name': 'TV 1000 Action',
              'resolutions': {}
            },
            {
              'id': '94c073fb-1b99-4344-8d55-57b8a7663af8',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/8f0894e4-c5ca-4aef-a1fd-86d4cf445d79.png',
              'name': 'Viasat  nature',
              'resolutions': {}
            },
            {
              'id': '102804c8-b116-4783-b8f3-20bf23ba1957',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/25209892-3115-4efc-8800-e01a6c4fbac3.png',
              'name': 'Viasat Sport',
              'resolutions': {}
            },
            {
              'id': '26805018-f18e-4ba0-8a28-994ceb4be83a',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/80cd3a89-3b39-4127-a92d-2afbf72e3a9c.png',
              'name':
              'Viasat  Hayotbek Mirzaqosimov Udevs, [19/09/23 11:01] history',
              'resolutions': {}
            },
            {
              'id': '0361df80-17d4-4435-bb16-9533ea11b3a1',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/6fdf73f9-cbab-45c9-8ec9-9a804a4471c3.png',
              'name': 'Viasat explorer',
              'resolutions': {}
            },
            {
              'id': 'c706fc48-f1c1-4f28-9ba2-ea06ae2403ea',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/f0f0044b-4254-4d49-bfe0-c8f629562ca6.png',
              'name': 'National Geographic',
              'resolutions': {}
            },
            {
              'id': 'd241b897-d896-4de5-b490-58b6babbb5f9',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/172581ae-d11e-43d2-acd5-b17c3de0360d.png',
              'name': 'Animal Planet',
              'resolutions': {}
            },
            {
              'id': '908facdf-2549-46bc-ab3e-9720c130008d',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/e73437f7-9a80-4a30-bc79-0095001499b9.png',
              'name': 'Discovery Channel',
              'resolutions': {}
            },
            {
              'id': '932c72d6-d2e2-4bbc-a930-cd8c3b0b2350',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/c9971d2d-a444-4bb8-9595-54b716ec0bd7.png',
              'name': 'RUTV',
              'resolutions': {}
            },
            {
              'id': 'a2312c5c-7142-4312-8dee-9e6b45809bb0',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/fdab6afa-6cd3-4376-a440-f402676c757c.png',
              'name': 'Discovery science',
              'resolutions': {}
            },
            {
              'id': '2e514cc7-1cef-4768-8932-39c77643dd9d',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/cefa678c-e2cf-4de3-957c-d1a1873ecd3d.png',
              'name': 'FTV',
              'resolutions': {}
            },
            {
              'id': '007d537e-4031-44da-9d1b-adf7a085ff5c',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/0b27ce2a-090c-425d-b2e3-3e0e53318005.png',
              'name': 'Zor TV HD',
              'resolutions': {}
            },
            {
              'id': '536de716-fba2-4efc-8548-23c1d17f927a',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/4a7f5262-b2e8-4b35-a8a3-4427485d50a2.png',
              'name': "МУЗ-ТВ O'ZBEKISTON",
              'resolutions': {}
            },
            {
              'id': 'c0f06350-c9f7-44c0-a813-a6a594892133',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/6de473e9-ecd9-4872-858c-a52f788a17fb.png',
              'name': 'Детский мир',
              'resolutions': {}
            },
            {
              'id': '12a62c3f-eb7e-46c6-8e51-a57cb63bcc2c',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/9c8f65b1-6d7a-4614-a50b-c3b980b4e17c.png',
              'name': 'Тайны Галактики',
              'resolutions': {}
            },
            {
              'id': '85a51c4b-3d6e-49a3-84df-70c476b60e04',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/5e61f56e-b741-4ea2-8c27-a2ef2af56f4f.png',
              'name': 'Музыка Первого',
              'resolutions': {}
            },
            {
              'id': '1b295830-c276-48bc-b662-72a099f1ab0b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/8e212676-6f03-4925-b957-ec5a9870c0e5.png',
              'name': 'CGTN',
              'resolutions': {}
            },
            {
              'id': 'be3e3752-6d20-45c2-be0b-74b4b909f01b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/05ba2c3c-6ba1-4339-835b-e8df97ca68c0.png',
              'name': 'МИР ',
              'resolutions': {}
            },
            {
              'id': 'b12fe39f-8979-4b1c-9bd5-0b77e580c7b5',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/73397147-f523-4a89-84c3-ac7f12a2a110.png',
              'name': 'МИР 24',
              'resolutions': {}
            },
            {
              'id': '4b128b19-5015-4692-9595-8e880f0eec2b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/6fa140c4-3a7c-4538-95f5-8be6fef389c2.png',
              'name': 'Домашний',
              'resolutions': {}
            },
            {
              'id': 'edaf8010-331d-43bc-af76-2e14165ccaa7',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/12fc7581-1e7a-4571-b9fa-6f1d54c5f798.png',
              'name': "O'zbekiston 24 HD",
              'resolutions': {}
            },
            {
              'id': '8c09f5a1-1327-4bfe-8b36-bad8684b3ecc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/bd2f9e5a-bb9f-4c93-8937-cff4ff7153b1.png',
              'name': 'Ocean TV',
              'resolutions': {}
            },
            {
              'id': 'd255671e-c00b-4815-a5e1-53082ff26ddf',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/d249c9ce-cc04-40bb-8eff-58c23ee8a37d.png',
              'name': 'MY 5 ',
              'resolutions': {}
            },
            {
              'id': '9a7b354c-40b3-4216-851b-466314dcc756',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/a958f39e-d79e-4c1b-a730-06e81dbb4f9f.png',
              'name': 'MYDAY TV',
              'resolutions': {}
            },
            {
              'id': '3536bb4a-06d1-49b0-87a1-9103e1a11032',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/131a4813-f906-4cff-bf8e-0281f1f24528.png',
              'name': 'TRT MUSIC',
              'resolutions': {}
            },
            {
              'id': '90034422-89f6-4cad-bc28-431be9608f19',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/b54e3c7d-d2f3-44f5-907b-9ab7e7f3850c.png',
              'name': 'Oʻzbekiston',
              'resolutions': {}
            },
            {
              'id': 'bd987d86-9ea3-4bff-ab69-1db19e9951f4',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/efe1ae3e-d32f-4ffb-b66f-53b5ed7a8529.png',
              'name': 'Hollywood',
              'resolutions': {}
            },
            {
              'id':
              '  Hayotbek Mirzaqosimov Udevs, [19/09/23 11:01] 1cf6507-636e-42a9-973d-43c599c72a3b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/ad33e76a-9c3c-4597-b7a0-afc45822006a.png',
              'name': 'TRT AVAZ',
              'resolutions': {}
            },
            {
              'id': '2666e36e-99fe-423d-b8ed-2dcfb0595c32',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/9add8f57-db7f-4b99-82c0-1e85bcc0c388.png',
              'name': ' СТС Kids',
              'resolutions': {}
            },
            {
              'id': 'b4a90a9f-1d72-4d16-9160-4e8fe992c06b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/35f05b8d-cd6d-4d13-b544-9dca1877050a.png',
              'name': 'Dasturxon TV',
              'resolutions': {}
            },
            {
              'id': '26dac9cd-2eac-4dc9-ba7f-c6e084a0a59a',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/0a8725f7-8384-4e10-8fee-853a959ddfe3.png',
              'name': 'Fashion TV',
              'resolutions': {}
            },
            {
              'id': '61ad6295-a312-4b18-a48a-236467922e85',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/5f2891cf-ae57-42e7-8878-cdf7b7259181.png',
              'name': 'LUX TV',
              'resolutions': {}
            },
            {
              'id': 'f9e6163f-4600-43a7-aa2b-16de567cbbba',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/87209c6e-d1ef-48bc-b046-4c398f93327d.png',
              'name': 'Телекафе',
              'resolutions': {}
            },
            {
              'id': '8b957f2e-6152-4aa2-a797-c09c1c4e4384',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/f432691a-1c28-4f80-a29d-8b3bb386891c.png',
              'name': 'Sevimli',
              'resolutions': {}
            },
            {
              'id': 'f063edd6-d7a1-4a21-8756-6fa8726b5278',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/8c00b401-0755-41f1-a902-139c6b48c423.png',
              'name': 'Дом Кино',
              'resolutions': {}
            },
            {
              'id': '3228eac2-bb3f-45d4-9568-46c725028daf',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/be8ffdf1-12d1-4c4a-a95a-a50cf0b7245f.png',
              'name': 'Звезда',
              'resolutions': {}
            },
            {
              'id': '7f2f390c-75cd-4e85-a461-9c5874a84940',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/47a6b4a3-ddd0-41d7-aa8e-4b15ea456107.png',
              'name': 'Milliy',
              'resolutions': {}
            },
            {
              'id': '3af5aa36-c13c-479a-b0c7-2a7c85c959a4',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/a74ef020-a73c-4bf7-83da-1aef16e0b7cb.png',
              'name': 'Ретро',
              'resolutions': {}
            },
            {
              'id': '214da4ab-cf97-48b7-9614-a1da6e040ecb',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/0346784a-26d5-4b2e-9848-8f90fbced24a.png',
              'name': 'Охота и Рыбалка',
              'resolutions': {}
            },
            {
              'id': '39bfa5dc-3e2a-4be6-804f-db40cfaa6bb0',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/de6bf6cd-151f-465c-b49e-34ecfe511771.png',
              'name': 'Авто плюс',
              'resolutions': {}
            },
            {
              'id': 'e171a767-d623-4f69-90bf-c3071f480d0b',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/d331f532-c155-4c78-8b6c-a8ee15446c60.png',
              'name': 'ТВ-3',
              'resolutions': {}
            },
            {
              'id': '5c5f969a-2972-4a9f-bebc-24671eadd567',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/d43063ce-82a3-41c1-9503-736f375a1309.png',
              'name': 'Карусель',
              'resolutions': {}
            },
            {
              'id': '89c02d0d-6c76-4f94-88c2-c5b7bf574b8f',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/0b223230-9a8d-46dd-b40f-762620efec10.png',
              'name': 'Da Vinci',
              'resolutions': {}
            },
            {
              'id': '35207e7c-62b7-47bf-ba58-e1f381ec90b0',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/b813bac7-ee7c-4141-92be-88dc03ffcd7a.png',
              'name': 'Кухня ТВ',
              'resolutions': {}
            },
            {
              'id': '89ac2d5e-9c59-4a3f-acc8-9802cae2ed08',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/8cb002e5-a7f6-4284-8a73-4508d0381f60.png',
              'name': 'Зоопарк',
              'resolutions': {}
            },
            {
              'id': '7866d816-1738-4714-b2fa-4333a50b28b1',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/b68cde9e-3aeb-4a9f-bc3b-4374c03dd733.png',
              'name': 'Уник-Ум',
              'resolutions': {}
            },
            {
              'id': 'e5055009-1c69-492b-8cc3-afff6b5b66a9',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/dedfe1ad-593b-4bdf-b6ba-4f1131a47a9d.png',
              'name': 'В гостях у сказки',
              'resolutions': {}
            },
            {
              'id': '2b526606-8155-4ccd-98fe-acb6a5498a2c',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/c180d29d-c536-4616-bd50-d0876b656aa3.png',
              'name': 'Qazaqstan Int',
              'resolutions': {}
            },
            {
              'id': '51f95aab-f744-45ca-b28f-529f79c3c45a',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/77b6dc21-659d-4ea7-9f29-c501b11de93c.png',
              'name': 'TOSHKENT',
              'resolutions': {}
            },
            {
              'id': '3868bf28-69aa-4413-abc6-4a1e046c63fc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/8414ee92-d6ab-4979-b8f3-7dbd66813b74.png',
              'name': 'Yoshlar',
              'resolutions': {}
            },
            {
              'id': '903d6f62-036e-4fdc-b32a-8ff15e69fc35',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/i  Hayotbek Mirzaqosimov Udevs, [19/09/23 11:01] ages/32572181-2134-4cd5-b278-945bf674982d.png',
              'name': "O'zbekiston Tarixi HD",
              'resolutions': {}
            },
            {
              'id': '5d1a0d2d-07f3-4917-9613-0dc0a6b8fa6f',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/08736714-e384-4c87-a747-5abb82914ab4.png',
              'name': "Madaniyat va Ma'rifat",
              'resolutions': {}
            },
            {
              'id': '994be080-9f0c-4522-a16c-68fc317b67bd',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/04e28700-13a7-49d4-bba8-8f1cb813f1ba.png',
              'name': 'Dunyo Boylab',
              'resolutions': {}
            },
            {
              'id': '83ec6e22-e11e-4b6a-9391-59ba8043abec',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/1e4ee1ad-c3d4-4131-bc43-74b7a1e29ea2.png',
              'name': 'NAVO',
              'resolutions': {}
            },
            {
              'id': '47f33a27-9001-4a92-9eb0-33c8857dbde9',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/c4e4bcc5-6edd-41be-8d49-aa88518eabb0.png',
              'name': 'BOLAJON',
              'resolutions': {}
            },
            {
              'id': '7024bf44-f355-4952-85be-0191def0a7ec',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/182f41ce-8efb-4719-a1a1-242d6492e63e.png',
              'name': 'KINOTEATR HD',
              'resolutions': {}
            },
            {
              'id': 'b40c2cf7-e1a6-4e7f-821d-b2221ff11222',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/b50558dd-51e1-4407-977e-1290a6a5a3f7.png',
              'name': 'Mahalla',
              'resolutions': {}
            },
            {
              'id': 'e024ebb0-dd2c-4db3-a3f9-228fcac4faf0',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/655856d0-6321-4d70-ae0f-ec4ce739c5ea.png',
              'name': 'Foreign-Languages',
              'resolutions': {}
            },
            {
              'id': '0befc9a1-4705-49af-b0a5-d6f39690e1c8',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/8c1046e8-e751-4d69-b8d8-69b7475f8edf.png',
              'name': 'Nurafshon TV',
              'resolutions': {}
            },
            {
              'id': 'd746146e-a329-4795-ba49-525216da0857',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/ccf0c699-bfc5-40a2-ad4b-a42699543ee5.png',
              'name': '365 дней ТВ',
              'resolutions': {}
            },
            {
              'id': 'b218f135-1438-4556-bcb5-89bd6acc26bc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/29f09812-674a-4c64-b41b-c93e1f72792b.png',
              'name': 'Ля-минор ТВ',
              'resolutions': {}
            },
            {
              'id': 'be177c9d-96c0-4ecc-b387-c2c8c8c0c454',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/46b22bfd-a077-4c0c-9441-70625dbb793a.png',
              'name': 'Дорама',
              'resolutions': {}
            },
            {
              'id': 'b121ebf9-6ce7-4dbf-8cc6-e748309ebb70',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/2a869603-1743-49c0-b457-aea25724d121.png',
              'name': 'History',
              'resolutions': {}
            },
            {
              'id': 'bfa2b019-de1e-4194-b1f9-98dcb4aa0bbb',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/93023023-a64d-4d08-af85-01744d59646d.png',
              'name': 'ТНВ Планета',
              'resolutions': {}
            },
            {
              'id': 'f310c203-d487-447c-99aa-22010927799d',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/7363c604-e0e6-41ea-b271-0193122014d1.png',
              'name': 'Buxoro',
              'resolutions': {}
            }
          ]
        },
        {
          'id': 'd761e3ce-6457-400e-adf8-8f86e1862fff',
          'title': 'Детские',
          'tvChannels': [
            {
              'id': 'eff25037-a336-49a0-9ff9-78ed665c8df5',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/49a693c3-2c6b-4d20-ae2d-48e2e063fb9f.png',
              'name': 'CNN',
              'resolutions': {}
            },
            {
              'id': '107edbec-1dfe-4c84-ae67-aae7ea4dfe77',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/bdd69ce9-8186-45a6-914a-4c992c5ea201.png',
              'name': 'Sport UZ',
              'resolutions': {}
            },
            {
              'id': 'e021050d-fdf1-4360-a913-992371d16c8e',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/f488b5f9-fc93-40b0-9394-200df5974fad.png',
              'name': 'Россия 1',
              'resolutions': {}
            },
          ]
        },
        {
          'id': '1d157249-86c1-40c0-9ad0-763da20ed342',
          'title': 'Познавательные',
          'tvChannels': [
            {
              'id': 'bfa2b019-de1e-4194-b1f9-98dcb4aa0bbb',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/93023023-a64d-4d08-af85-01744d59646d.png',
              'name': 'ТНВ Планета',
              'resolutions': {}
            },
            {
              'id': 'f310c203-d487-447c-99aa-22010927799d',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/7363c604-e0e6-41ea-b271-0193122014d1.png',
              'name': 'Buxoro',
              'resolutions': {}
            }
          ]
        },
        {
          'id': '976aafb5-a5f8-403e-9559-1d8f041a6c7d',
          'title': 'Новостные',
          'tvChannels': []
        },
        {
          'id': '2c503c02-413e-47d7-ad56-9768dab78071',
          'title': 'Музыкальные',
          'tvChannels': [
            {
              'id': 'd746146e-a329-4795-ba49-525216da0857',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/ccf0c699-bfc5-40a2-ad4b-a42699543ee5.png',
              'name': '365 дней ТВ',
              'resolutions': {}
            },
            {
              'id': 'b218f135-1438-4556-bcb5-89bd6acc26bc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/29f09812-674a-4c64-b41b-c93e1f72792b.png',
              'name': 'Ля-минор ТВ',
              'resolutions': {}
            },
            {
              'id': 'be177c9d-96c0-4ecc-b387-c2c8c8c0c454',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/46b22bfd-a077-4c0c-9441-70625dbb793a.png',
              'name': 'Дорама',
              'resolutions': {}
            },
          ]
        },
        {
          'id': '682f2e44-6b5b-4c5d-bb54-c275d6cfef97',
          'title': 'Кино',
          'tvChannels': [
            {
              'id': 'd746146e-a329-4795-ba49-525216da0857',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/ccf0c699-bfc5-40a2-ad4b-a42699543ee5.png',
              'name': '365 дней ТВ',
              'resolutions': {}
            },
            {
              'id': 'b218f135-1438-4556-bcb5-89bd6acc26bc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/29f09812-674a-4c64-b41b-c93e1f72792b.png',
              'name': 'Ля-минор ТВ',
              'resolutions': {}
            },
            {
              'id': 'be177c9d-96c0-4ecc-b387-c2c8c8c0c454',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/46b22bfd-a077-4c0c-9441-70625dbb793a.png',
              'name': 'Дорама',
              'resolutions': {}
            },
          ]
        },
        {
          'id': '547216f1-fd58-42ce-9e51-9f6d7b51bb0a',
          'title': 'Спортивные ',
          'tvChannels': [
            {
              'id': 'd746146e-a329-4795-ba49-525216da0857',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/ccf0c699-bfc5-40a2-ad4b-a42699543ee5.png',
              'name': '365 дней ТВ',
              'resolutions': {}
            },
            {
              'id': 'b218f135-1438-4556-bcb5-89bd6acc26bc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/29f09812-674a-4c64-b41b-c93e1f72792b.png',
              'name': 'Ля-минор ТВ',
              'resolutions': {}
            },
            {
              'id': 'be177c9d-96c0-4ecc-b387-c2c8c8c0c454',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/46b22bfd-a077-4c0c-9441-70625dbb793a.png',
              'name': 'Дорама',
              'resolutions': {}
            },
          ]
        },
        {
          'id': '16391f05-894c-49a8-8aa5-b1bdb60e6432',
          'title': 'Национальные',
          'tvChannels': [
            {
              'id': 'd746146e-a329-4795-ba49-525216da0857',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/ccf0c699-bfc5-40a2-ad4b-a42699543ee5.png',
              'name': '365 дней ТВ',
              'resolutions': {}
            },
            {
              'id': 'b218f135-1438-4556-bcb5-89bd6acc26bc',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/29f09812-674a-4c64-b41b-c93e1f72792b.png',
              'name': 'Ля-минор ТВ',
              'resolutions': {}
            },
            {
              'id': 'be177c9d-96c0-4ecc-b387-c2c8c8c0c454',
              'image':
              'https://cdn.uzd.udevs.io/uzdigital/images/46b22bfd-a077-4c0c-9441-70625dbb793a.png',
              'name': 'Дорама',
              'resolutions': {}
            },
          ]
        }
      ]
    });
    return UdevsVideoPlayerPlatform.instance.playVideo(
      playerConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> downloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.downloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> pauseDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.pauseDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> resumeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.resumeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<bool> isDownloadVideo({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.isDownloadVideo(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getCurrentProgressDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getCurrentProgressDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Stream<MediaItemDownload> get currentProgressDownloadAsStream =>
      UdevsVideoPlayerPlatform.instance.currentProgressDownloadAsStream();

  Future<int?> getStateDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getStateDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getBytesDownloaded({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getBytesDownloaded(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<int?> getContentBytesDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.getContentBytesDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  Future<dynamic> removeDownload({
    required DownloadConfiguration downloadConfig,
  }) {
    final String jsonStringConfig = jsonEncode(downloadConfig.toJson());
    return UdevsVideoPlayerPlatform.instance.removeDownload(
      downloadConfigJsonString: jsonStringConfig,
    );
  }

  void dispose() => UdevsVideoPlayerPlatform.instance.dispose();
}
