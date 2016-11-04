--Hinata, Queen of Gust Vine
function c500315100.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c500315100.spcon)
	e1:SetOperation(c500315100.spop)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
		--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,500315100)
	e3:SetCondition(c500315100.condition)
	e3:SetCost(c500315100.cost)
	e3:SetTarget(c500315100.target)
	e3:SetOperation(c500315100.operation)
	c:RegisterEffect(e3)
	
		local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	
		--Immune
 local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_REMOVE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(0x3f)
    e6:SetTargetRange(0,1)
    e6:SetTarget(c500315100.remtg)
    c:RegisterEffect(e6)
		--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(500315100,0))
	e7:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCountLimit(1,500315100)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCondition(c500315100.descon)
	e7:SetTarget(c500315100.destg)
	e7:SetOperation(c500315100.desop)
	e7:SetLabelObject(e1)
	c:RegisterEffect(e7)
end

function c500315100.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c500315100.cfilter,tp,LOCATION_HAND,0,2,nil)
end
function c500315100.spop(e,tp,eg,ep,ev,re,r,rp,c)

	Duel.DiscardHand(tp,c500315100.cfilter,2,2,REASON_COST)
end
function c500315100.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and not e:GetHandler():IsReason(REASON_RETURN)
end

function c500315100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(c500315100.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c500315100.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c500315100.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL and re==e:GetLabelObject() and e:GetHandler():GetSummonLocation()==LOCATION_HAND
end
function c500315100.ssfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:IsAbleToDeck()
end
function c500315100.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(c500315100.ssfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TO_DECK,sg,sg:GetCount(),0,0)
end
function c500315100.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c500315100.sgop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c500315100.ssfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler()) 
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function c500315100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c500315100.cfilter(c)
	return  c:IsSetCard(0x786d) and c:IsType(TYPE_MONSTER)  and c:IsAbleToGrave() --and not c:IsCode(500315100) 
end
function c500315100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(c500315100.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c500315100.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c500315100.filter(c)
	return  c:IsSetCard(0x786d) and c:IsType(TYPE_MONSTER) and not c:IsCode(500315100) and c:IsAbleToHand()
end
function c500315100.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500315100.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c500315100.remtg(e,c)
    return c==e:GetHandler()
end
function c500315100.descon(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL and re==e:GetLabelObject() and e:GetHandler():GetSummonLocation()==LOCATION_HAND
end
function c500315100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		if tc:IsFaceup() and tc:GetSummonLocation()==LOCATION_EXTRA and not tc:IsType(TYPE_FUSION)  then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		end
	end
end
function c500315100.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsLocation(LOCATION_REMOVED) and tc:IsType(TYPE_MONSTER) and tc:GetSummonLocation()==LOCATION_EXTRA  and not tc:IsType(TYPE_FUSION) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
