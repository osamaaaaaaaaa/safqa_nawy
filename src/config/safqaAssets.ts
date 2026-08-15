import aboutImage from '../assets/about.jpg'
import heroImage from '../assets/findstate-hero.jpg'
import listingOneImage from '../assets/listing-1.jpg'
import listingTwoImage from '../assets/listing-2.jpg'
import listingThreeImage from '../assets/listing-3.jpg'
import personOneImage from '../assets/person-1.jpg'
import personTwoImage from '../assets/person-2.jpg'
import personThreeImage from '../assets/person-3.jpg'
import propertyOneImage from '../assets/property-1.jpg'
import propertyTwoImage from '../assets/property-2.jpg'
import propertyThreeImage from '../assets/property-3.jpg'
import propertyFourImage from '../assets/property-4.jpg'

export const safqaAssetKeys = {
  hero: 'safqa.hero',
  about: 'safqa.about',
  listingOne: 'safqa.listing.one',
  listingTwo: 'safqa.listing.two',
  listingThree: 'safqa.listing.three',
  personOne: 'safqa.person.one',
  personTwo: 'safqa.person.two',
  personThree: 'safqa.person.three',
  propertyOne: 'safqa.property.one',
  propertyTwo: 'safqa.property.two',
  propertyThree: 'safqa.property.three',
  propertyFour: 'safqa.property.four',
} as const

export type SafqaAssetKey = (typeof safqaAssetKeys)[keyof typeof safqaAssetKeys]

export const safqaAssets: Record<SafqaAssetKey, string> = {
  [safqaAssetKeys.hero]: heroImage,
  [safqaAssetKeys.about]: aboutImage,
  [safqaAssetKeys.listingOne]: listingOneImage,
  [safqaAssetKeys.listingTwo]: listingTwoImage,
  [safqaAssetKeys.listingThree]: listingThreeImage,
  [safqaAssetKeys.personOne]: personOneImage,
  [safqaAssetKeys.personTwo]: personTwoImage,
  [safqaAssetKeys.personThree]: personThreeImage,
  [safqaAssetKeys.propertyOne]: propertyOneImage,
  [safqaAssetKeys.propertyTwo]: propertyTwoImage,
  [safqaAssetKeys.propertyThree]: propertyThreeImage,
  [safqaAssetKeys.propertyFour]: propertyFourImage,
}
