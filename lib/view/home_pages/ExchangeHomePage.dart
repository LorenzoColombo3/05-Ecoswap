import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../data/repository/IAdRepository.dart';
import '../../data/viewmodel/AdViewModel.dart';
import '../../data/viewmodel/AdViewModelFactory.dart';
import '../../model/Exchange.dart';
import '../../model/UserModel.dart';
import '../../util/ServiceLocator.dart';

class ExchangeHomePage extends StatefulWidget {
  final UserModel currentUser;

  const ExchangeHomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ExchangeHomePage> createState() => _ExchangeHomePageState();
}

class _ExchangeHomePageState extends State<ExchangeHomePage> {
  late IAdRepository adRepository;
  late AdViewModel adViewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Exchange> _exchanges = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    adRepository = ServiceLocator().getAdRepository();
    adViewModel = AdViewModelFactory(adRepository).create();
    _loadMoreData(index);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadMoreData(int index) async {
    setState(() {
      _isLoading = true;
    });
    List<Exchange> additionalData = await adViewModel.getExchangesInRadius(
        widget.currentUser.latitude, widget.currentUser.longitude, 30, index);
    setState(() {
      _exchanges.addAll(additionalData);
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData(_exchanges.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.builder(
            shrinkWrap: true, // Imposta shrinkWrap a true per consentire al GridView di adattarsi al suo contenuto
            physics: NeverScrollableScrollPhysics(), // Disabilita lo scroll all'interno del GridView
            itemCount: _exchanges.length + (_isLoading ? 1 : 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              mainAxisExtent: 300,
            ),
            itemBuilder: (BuildContext context, int index) {
              if (index < _exchanges.length) {
                return _buildExchangeItem(_exchanges[index]);
              } else {
                print (-_exchanges.length);
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildExchangeItem(Exchange exchange) {
    return GestureDetector(
        onTap: () {
      // Azione da eseguire quando il Container viene toccato
      print('Container toccato!');
    },
    child: Container(
        padding: const EdgeInsets.all( 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/image/loading_indicator.gif'), // Immagine di placeholder (un'animazione di caricamento circolare, ad esempio)
                height: 200,
                image: NetworkImage(exchange.imageUrl), // URL dell'immagine principale
                fit: BoxFit.cover, // Adatta l'immagine all'interno del container
              ),
            ),Stack(
              children: [
                ListTile(
                  onTap: () {
                    // Aggiungere qui la logica da eseguire quando viene toccato il ListTile
                  },
                  title: Text(
                    exchange.title,
                    overflow: TextOverflow.ellipsis, // Testo non va a capo
                  ),
                  subtitle: Text(
                    "inserire qualcosa",
                    overflow: TextOverflow.ellipsis, // Testo non va a capo
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      // Aggiungere qui la logica per gestire il tap sull'icona del cuore
                      // Ad esempio, potresti aggiornare lo stato per indicare che questo elemento è contrassegnato come preferito
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0), // Personalizza il padding dell'icona
                      child: Icon(
                        Icons.favorite, // Icona del cuore come preferito
                        color: Colors.grey, // Colore rosso per indicare che è contrassegnato come preferito
                        size: 24.0, // Dimensione dell'icona personalizzata
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}