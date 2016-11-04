function c50031481.initial_effect(c)
					--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,500314820)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c50031481.thtg)
	e2:SetOperation(c50031481.thop)
	c:RegisterEffect(e2)
		--spsummon
local e3=Effect.CreateEffect(c)
e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(50031481,0))
e3:SetType(EFFECT_TYPE_IGNITION)
e3:SetCountLimit(1,50031481)
	e3:SetCountLimit(1,50031481)
e3:SetCondition(c50031481.condition)
e3:SetRange(LOCATION_MZONE)
e3:SetTarget(c50031481.sctg)
e3:SetOperation(c50031481.scop)
c:RegisterEffect(e3)
end

function c50031481.thfilter(c)
	return c:IsSetCard(0x785b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c50031481.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50031481.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c50031481.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c50031481.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if Duel.ConfirmCards(1-tp,g)~=0 then
				local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetDescription(aux.Stringid(50031481,1))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetTarget(c50031481.sumtg)
	e3:SetOperation(c50031481.sumop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	Duel.RegisterFlagEffect(tp,50031481,RESET_PHASE+PHASE_END,0,1)
	end
end
end

function c50031481.cfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81
end
function c50031481.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c50031481.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c50031481.filter(c,e,tp,m)
return  c:IsSetCard(0x785b) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c50031481.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c50031481.filter1(c,e,tp,cg)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false)
		and cg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
end
function c50031481.cgfilter(c)
	return c:GetLevel()>0 and  c:IsSetCard(0x785b) and c:IsReleasable()
end
function c50031481.filter(c,e,tp,lv)
return c:IsFaceup() and c:GetLevel()>0
and Duel.IsExistingMatchingCard(c50031481.scfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv+c:GetOriginalLevel())
end
function c50031481.scfilter(c,e,tp,lv)
return c:GetLevel()<=lv and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x785b)
and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c50031481.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chkc then return false end
local lv=e:GetHandler():GetOriginalLevel()
if chk==0 then return Duel.IsExistingTarget(c50031481.cgfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,lv) end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=Duel.SelectTarget(tp,c50031481.cgfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,lv)
g:AddCard(e:GetHandler())
Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50031481.scop(e,tp,eg,ep,ev,re,r,rp)
if  Duel.IsExistingMatchingCard(c50031481.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then return end
local c=e:GetHandler()
local tc=Duel.GetFirstTarget()
if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
local g=Group.FromCards(c,tc)
if Duel.SendtoGrave(g,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)==2 and c:GetLevel()>0 and c:IsLocation(LOCATION_GRAVE)
and tc:GetLevel()>0 and tc:IsLocation(LOCATION_GRAVE) then
local lv=c:GetLevel()+tc:GetLevel()
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local sg=Duel.SelectMatchingCard(tp,c50031481.scfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv)
local tc=sg:GetFirst()
if tc then
Duel.BreakEffect()
tc:SetMaterial(g)
Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
tc:CompleteProcedure()
end
end
end
function c50031481.rfilter(c)
	return c:IsSetCard(0x785b) and not c:IsCode(50031481) and c:IsSummonable(true,nil)
end
function c50031481.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50031481.rfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c50031481.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c50031481.rfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end