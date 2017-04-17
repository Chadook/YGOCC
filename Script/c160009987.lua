--Blue-Eyes White Mage
function c160009987.initial_effect(c)
		aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x785c),5,3,c160009987.ovfilter,aux.Stringid(160009987,0))
	c:EnableReviveLimit()
		--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
		--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(160009987,0))
	e2:SetProperty(EFFECT_FLAG2_XMDETACH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCondition(c160009987.condition)
	e2:SetCost(c160009987.cost)
	e2:SetTarget(c160009987.target)
	e2:SetOperation(c160009987.operation)
	c:RegisterEffect(e2)
end
function c160009987.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x785c) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function c160009987.filter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA or c:GetSummonLocation()==LOCATION_HAND
end
function c160009987.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and eg:IsExists(c160009987.filter,1,nil)
end
function c160009987.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c160009987.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c160009987.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c160009987.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c160009987.filter,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
end