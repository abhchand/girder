/*
 * Loads translations and makes them available in a global `I18n` object
 */
import { I18n } from 'i18n-js';
import translations from './translations.json';

window.I18n = new I18n(translations);
