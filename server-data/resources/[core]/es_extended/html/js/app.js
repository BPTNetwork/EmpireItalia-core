(() => {
	const ESX = {};

	ESX.inventoryNotification = function(add, label, count) {
		let notif = '';

		notif += add ? '+' : '-';
		notif += count ? `${count} ${label}` : ` ${label}`;

		const elem = $('<div></div>').text(notif);
		$('#inventory_notifications').append(elem);

		$(elem)
			.delay(3000)
			.fadeOut(1000, function() {
				elem.remove();
			});
	};

	window.ESX = ESX;

	window.onData = (data) => {
		if (data.action === 'inventoryNotification') {
			ESX.inventoryNotification(data.add, data.item, data.count);
		}
	};

	window.onload = function() {
		window.addEventListener('message', (event) => {
			if (event.origin !== 'nui://game' && event.origin !== '') return;

			if (typeof event.data !== 'object' || !event.data.action) return;

			onData(event.data);
		});
	};
})();
