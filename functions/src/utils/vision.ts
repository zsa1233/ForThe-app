/**
 * Google Cloud Vision API utilities for image analysis
 */

import vision from '@google-cloud/vision';

// Initialize Vision client
const client = new vision.ImageAnnotatorClient();



// Plastic trash items
const PLASTIC_ITEMS = [
  'Bottle',
  'Plastic bottle',
  'Water bottle',
  'Soda bottle',
  'Plastic bag',
  'Shopping bag',
  'Plastic container',
  'Food container',
  'Takeout container',
  'Plastic cup',
  'Disposable cup',
  'Plastic utensils',
  'Straw',
  'Plastic wrapper',
  'Plastic packaging',
  'Tupperware',
  'Yogurt container',
  'Milk jug',
  'Plastic',
];

// Paper trash items
const PAPER_ITEMS = [
  'Paper',
  'Newspaper',
  'Magazine',
  'Cardboard',
  'Box',
  'Cardboard box',
  'Paper bag',
  'Paper cup',
  'Coffee cup',
  'Paper plate',
  'Napkin',
  'Tissue',
  'Paper towel',
  'Receipt',
  'Flyer',
  'Brochure',
  'Book',
  'Paper wrapper',
  'Pizza box',
  'Cereal box',
  'Package',
  'Packaging',
  'Envelope',
];

// Glass trash items
const GLASS_ITEMS = [
  'Glass',
  'Glass bottle',
  'Beer bottle',
  'Wine bottle',
  'Jar',
  'Glass jar',
  'Glass container',
  'Broken glass',
  'Glass cup',
  'Drinking glass',
  'Window',
  'Mirror',
];

// Metal trash items
const METAL_ITEMS = [
  'Can',
  'Aluminum can',
  'Soda can',
  'Beer can',
  'Tin can',
  'Food can',
  'Metal container',
  'Metal lid',
  'Bottle cap',
  'Foil',
  'Aluminum foil',
  'Metal',
  'Steel',
  'Iron',
  'Copper',
  'Scrap metal',
];

// Organic waste items
const ORGANIC_ITEMS = [
  'Food',
  'Food waste',
  'Fruit',
  'Vegetable',
  'Apple',
  'Banana',
  'Orange',
  'Leaf',
  'Leaves',
  'Branch',
  'Stick',
  'Organic waste',
  'Compost',
  'Garden waste',
  'Yard waste',
  'Grass',
  'Flower',
  'Plant',
  'Tree debris',
  'Food scraps',
];

// Electronic waste items
const ELECTRONIC_ITEMS = [
  'Electronics',
  'Electronic',
  'Phone',
  'Mobile phone',
  'Smartphone',
  'Computer',
  'Laptop',
  'Tablet',
  'Television',
  'TV',
  'Monitor',
  'Keyboard',
  'Mouse',
  'Cable',
  'Wire',
  'Battery',
  'Charger',
  'Headphones',
  'Speaker',
  'Radio',
  'Camera',
  'Electronic device',
  'Circuit board',
];

// Other/miscellaneous trash items
const OTHER_ITEMS = [
  'Waste',
  'Debris',
  'Litter',
  'Trash',
  'Garbage',
  'Rubber',
  'Tire',
  'Fabric',
  'Clothing',
  'Shoe',
  'Cigarette',
  'Cigarette butt',
  'Stub',
  'Lighter',
  'Toy',
  'Furniture',
  'Wood',
  'Ceramic',
  'Porcelain',
  'Styrofoam',
  'Foam',
  'Miscellaneous',
  'Unknown object',
];

// Combined list for general trash detection
const TRASH_OBJECT_NAMES = [
  ...PLASTIC_ITEMS,
  ...PAPER_ITEMS,
  ...GLASS_ITEMS,
  ...METAL_ITEMS,
  ...ORGANIC_ITEMS,
  ...ELECTRONIC_ITEMS,
  ...OTHER_ITEMS,
];

/**
 * Analyzes an image for object detection and returns potential trash objects
 * @param imageUrl URL or path to the image
 * @returns Array of detected objects
 */
export async function analyzeImageForObjects(imageUrl: string) {
  try {
    if (!client || !client.objectLocalization) {
      throw new Error('Vision API client not properly initialized');
    }
    const [result] = await client.objectLocalization({ image: { source: { imageUri: imageUrl } } });
    return result.localizedObjectAnnotations || [];
  } catch (error) {
    console.error('Error analyzing image for objects:', error);
    throw new Error(`Vision API error: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

/**
 * Analyzes an image for label detection (general content)
 * @param imageUrl URL or path to the image
 * @returns Array of detected labels
 */
export async function analyzeImageForLabels(imageUrl: string) {
  try {
    if (!client || !client.labelDetection) {
      throw new Error('Vision API client not properly initialized');
    }
    const [result] = await client.labelDetection({ image: { source: { imageUri: imageUrl } } });
    return result.labelAnnotations || [];
  } catch (error) {
    console.error('Error analyzing image for labels:', error);
    throw new Error(`Vision API error: ${error instanceof Error ? error.message : 'Unknown error'}`);
  }
}

/**
 * Counts potential trash objects in the detected objects
 * @param objects Array of detected objects from Vision API
 * @returns Number of potential trash objects
 */
export function countPotentialTrash(objects: any[]): number {
  if (!objects || !Array.isArray(objects)) {
    return 0;
  }

  return objects.filter((obj) => {
    if (!obj.name) return false;
    
    const objectName = obj.name.toLowerCase();
    return TRASH_OBJECT_NAMES.some(trashType => 
      objectName.includes(trashType.toLowerCase())
    );
  }).length;
}

/**
 * Categorizes detected objects by Terra app trash types
 * @param objects Array of detected objects from Vision API
 * @returns Object with categorized trash counts
 */
export function categorizeTrashByType(objects: any[]): {
  plastic: number;
  paper: number;
  glass: number;
  metal: number;
  organic: number;
  electronic: number;
  other: number;
  total: number;
  details: {
    plastic: string[];
    paper: string[];
    glass: string[];
    metal: string[];
    organic: string[];
    electronic: string[];
    other: string[];
  };
} {
  if (!objects || !Array.isArray(objects)) {
    return {
      plastic: 0, paper: 0, glass: 0, metal: 0, organic: 0, electronic: 0, other: 0, total: 0,
      details: { plastic: [], paper: [], glass: [], metal: [], organic: [], electronic: [], other: [] }
    };
  }

  const categorized = {
    plastic: 0, paper: 0, glass: 0, metal: 0, organic: 0, electronic: 0, other: 0,
    details: {
      plastic: [] as string[], paper: [] as string[], glass: [] as string[], 
      metal: [] as string[], organic: [] as string[], electronic: [] as string[], other: [] as string[]
    }
  };

  objects.forEach((obj) => {
    if (!obj.name) return;
    
    const objectName = obj.name.toLowerCase();
    let categorized_item = false;

    // Check each category
    if (PLASTIC_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.plastic++;
      categorized.details.plastic.push(obj.name);
      categorized_item = true;
    }
    
    if (!categorized_item && PAPER_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.paper++;
      categorized.details.paper.push(obj.name);
      categorized_item = true;
    }
    
    if (!categorized_item && GLASS_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.glass++;
      categorized.details.glass.push(obj.name);
      categorized_item = true;
    }
    
    if (!categorized_item && METAL_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.metal++;
      categorized.details.metal.push(obj.name);
      categorized_item = true;
    }
    
    if (!categorized_item && ORGANIC_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.organic++;
      categorized.details.organic.push(obj.name);
      categorized_item = true;
    }
    
    if (!categorized_item && ELECTRONIC_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.electronic++;
      categorized.details.electronic.push(obj.name);
      categorized_item = true;
    }
    
    if (!categorized_item && OTHER_ITEMS.some(item => objectName.includes(item.toLowerCase()))) {
      categorized.other++;
      categorized.details.other.push(obj.name);
    }
  });

  const total = categorized.plastic + categorized.paper + categorized.glass + 
                categorized.metal + categorized.organic + categorized.electronic + categorized.other;

  return { ...categorized, total };
}

/**
 * Counts potential trash in labels (fallback method)
 * @param labels Array of detected labels from Vision API
 * @returns Number of potential trash-related labels
 */
export function countTrashInLabels(labels: any[]): number {
  if (!labels || !Array.isArray(labels)) {
    return 0;
  }

  return labels.filter((label) => {
    if (!label.description) return false;
    
    const labelDesc = label.description.toLowerCase();
    return TRASH_OBJECT_NAMES.some(trashType => 
      labelDesc.includes(trashType.toLowerCase())
    ) || ['waste', 'litter', 'debris', 'trash', 'garbage'].some(term =>
      labelDesc.includes(term)
    );
  }).length;
}

/**
 * Comprehensive image analysis for cleanup verification
 * @param imageUrl URL to the image
 * @returns Analysis results including object count and confidence
 */
export async function analyzeCleanupImage(imageUrl: string) {
  try {
    // Run both object detection and label detection
    const [objectResult, labelResult] = await Promise.all([
      analyzeImageForObjects(imageUrl).catch(() => []),
      analyzeImageForLabels(imageUrl).catch(() => [])
    ]);

    const objectTrashCount = countPotentialTrash(objectResult);
    const labelTrashCount = countTrashInLabels(labelResult);

    // Categorize trash by Terra app types
    const trashCategories = categorizeTrashByType(objectResult);

    // Use the higher count for better accuracy
    const trashCount = Math.max(objectTrashCount, labelTrashCount, trashCategories.total);

    // Calculate confidence based on detection method
    let confidence = 0.5; // Base confidence
    if (objectResult.length > 0) {
      confidence += 0.3; // Higher confidence if objects detected
    }
    if (labelResult.length > 0) {
      confidence += 0.2; // Additional confidence from labels
    }
    
    // Boost confidence if we have categorized items
    if (trashCategories.total > 0) {
      confidence += 0.1;
    }

    return {
      trashCount,
      confidence: Math.min(confidence, 1.0),
      objectsDetected: objectResult.length,
      labelsDetected: labelResult.length,
      trashCategories,
      details: {
        objects: objectResult.slice(0, 10), // Limit for performance
        labels: labelResult.slice(0, 10),
        categorizedTrash: {
          plastic: trashCategories.details.plastic.slice(0, 5),
          paper: trashCategories.details.paper.slice(0, 5),
          glass: trashCategories.details.glass.slice(0, 5),
          metal: trashCategories.details.metal.slice(0, 5),
          organic: trashCategories.details.organic.slice(0, 5),
          electronic: trashCategories.details.electronic.slice(0, 5),
          other: trashCategories.details.other.slice(0, 5),
        }
      }
    };
  } catch (error) {
    console.error('Error in comprehensive image analysis:', error);
    throw error;
  }
}

/**
 * Validates image URL format and accessibility
 * @param imageUrl Image URL to validate
 * @returns True if URL appears valid
 */
export function isValidImageUrl(imageUrl: string): boolean {
  if (!imageUrl || typeof imageUrl !== 'string') {
    return false;
  }

  // Basic URL validation
  try {
    const url = new URL(imageUrl);
    return ['http:', 'https:', 'gs:'].includes(url.protocol);
  } catch {
    return false;
  }
}

/**
 * Calculates cleanup effectiveness based on before/after analysis
 * @param beforeAnalysis Analysis of before image
 * @param afterAnalysis Analysis of after image
 * @returns Cleanup effectiveness metrics
 */
export function calculateCleanupEffectiveness(
  beforeAnalysis: { trashCount: number; confidence: number },
  afterAnalysis: { trashCount: number; confidence: number }
) {
  const { trashCount: beforeCount, confidence: beforeConfidence } = beforeAnalysis;
  const { trashCount: afterCount, confidence: afterConfidence } = afterAnalysis;

  // Calculate reduction percentage
  const reductionPercentage = beforeCount > 0 
    ? ((beforeCount - afterCount) / beforeCount) * 100 
    : 0;

  // Calculate overall confidence
  const overallConfidence = (beforeConfidence + afterConfidence) / 2;

  // Determine if cleanup was effective (70% reduction threshold)
  const isEffective = reductionPercentage >= 70 && overallConfidence > 0.5;

  return {
    reductionPercentage: Math.max(0, Math.min(100, reductionPercentage)),
    overallConfidence,
    isEffective,
    beforeCount,
    afterCount,
    trashRemoved: Math.max(0, beforeCount - afterCount)
  };
}